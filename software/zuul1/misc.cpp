#define SYSTEM_BUS_WIDTH 32

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <altera_avalon_pio_regs.h>
#include <sys/alt_irq.h>
#include <io.h>
#include "misc.h"
#include <fcntl.h>

// 0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f
const uint8_t lut[] = {0x40, 0xf9, 0x24, 0x30, 0x99, 0x92, 0x82, 0xf8, 0x00, 0x10, 0x08, 0x83, 0xc6, 0xe1, 0x86, 0x8e};

void DuoSegment::setInt(unsigned int n)
{
    unsigned int a = n / 10 % 10;
    unsigned int b = n % 10;
    *base = lut[a] << 8 | lut[b];
}

void DuoSegment::setHex(uint8_t n)
{
    *base = lut[n >> 4] << 8 | lut[n % 16];
}

void QuadroSegment::setHex(uint16_t n)
{
    *base = lut[n >> 12] << 24 | lut[(n >> 8) % 16] << 16 | lut[(n >> 4) % 16] << 8 | lut[n % 16];
}

CombinedSegment::CombinedSegment(DuoSegment *l, DuoSegment *r, QuadroSegment *q)
{
    this->l = l;
    this->r = r;
    this->q = q;
}

void CombinedSegment::setHex(uint32_t n)
{
    l->setHex(n >> 24);
    r->setHex(n >> 16);
    q->setHex((uint16_t)n);
}

void CombinedSegment::setInt(unsigned int n)
{
    l->setInt(n / 1000000);
    r->setInt(n / 10000);
    q->setInt(n);
}

void QuadroSegment::setInt(unsigned int n)
{
    unsigned int a = n / 1000 % 10;
    unsigned int b = n / 100 % 10;
    unsigned int c = n / 10 % 10;
    unsigned int d = n % 10;
    *base = lut[a] << 24 | lut[b] << 16 | lut[c] << 8 | lut[d];
}

void InfraRood::init(volatile uint32_t *base, int irq, int ctl)
{
    this->base = base;
    alt_ic_isr_register(ctl, irq, isrBridge, 0, 0);
    IOWR(base, 0, 0);
}

void InfraRood::isr(void *context)
{
    if (observer != 0)
        observer->update();

    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(base, 0);
    IOWR(base, 0, 0);
}

void InfraRood::setObserver(Observer *observer)
{
    this->observer = observer;
}

void InfraRood::isrBridge(void *context)
{
    InfraRood::getInstance()->isr(context);
}

InfraRood *InfraRood::getInstance()
{
    static InfraRood instance;
    return &instance;
}

Uart *Uart::getInstance()
{
    static Uart instance;
    return &instance;
}

void Uart::init(volatile uint32_t *base)
{
    this->base = base;
}

void Uart::putc(const char c)
{
    while ((base[2] & (1<<6)) == 0)
    {
    }

    base[1] = c;
}

void Uart::puts(const char *s)
{
    while (*s)
        putc(*s++);
}

bool SDCard::write(int sd_fileh, char c)
{
    return ::alt_up_sd_card_write(sd_fileh, c);
}

bool SDCard::fclose(int sd_fileh)
{
    return ::alt_up_sd_card_fclose(sd_fileh);
}

VGA::VGA(const char *devName)
{
    charBuffer = ::alt_up_char_buffer_open_dev(devName);
}

int VGA::draw(const char c, const int x, const int y)
{
    return ::alt_up_char_buffer_draw(charBuffer, c, x, y);
}

int VGA::draw(const char *s, const int x, const int y)
{
    return ::alt_up_char_buffer_string(charBuffer, s, x, y);
}

bool SoundCard::init()
{
    regWrite(15, DATA_RESET);
    regWrite(9, DATA_INACTIVE_INTERFACE);
    regWrite(9, ACTIVE);
}

bool SoundCard::regWrite(uint8_t index, uint16_t data)
{
    i2cBus->write(ADDR, 1, 1);
}

void I2C::init(volatile uint32_t *scl, volatile uint32_t *sda)
{
    this->scl = scl;
    this->sda = sda;
}

void I2C::write(uint8_t devAddr, uint8_t ctlAddr, uint8_t ctlData)
{
    start();
    private_write(devAddr);
    private_write(ctlAddr);
    private_write(ctlData);
    stop();
    ::usleep(7*1000);
}

void I2C::start()
{
    IOWR_ALTERA_AVALON_PIO_DIRECTION(sda, 1);
    IOWR_ALTERA_AVALON_PIO_DATA(sda, 1);
    IOWR_ALTERA_AVALON_PIO_DATA(scl, 1);
    ::usleep(1);
    IOWR_ALTERA_AVALON_PIO_DATA(sda, 0);
    ::usleep(1);
    IOWR_ALTERA_AVALON_PIO_DATA(scl, 0);
    ::usleep(1);
}

void I2C::stop()
{
    IOWR_ALTERA_AVALON_PIO_DIRECTION(sda, 1);
    IOWR_ALTERA_AVALON_PIO_DATA(sda, 0);
    IOWR_ALTERA_AVALON_PIO_DATA(scl, 1);
    ::usleep(1);
    IOWR_ALTERA_AVALON_PIO_DATA(sda, 1);
    ::usleep(1);
}

bool I2C::private_write(uint8_t data)
{
    uint8_t mask = 0x80;
    IOWR_ALTERA_AVALON_PIO_DIRECTION(sda, 1);

    for (int i = 0; i < 8; i++)
    {
        IOWR_ALTERA_AVALON_PIO_DATA(scl, 0);
        
        if (data & mask)
            IOWR_ALTERA_AVALON_PIO_DATA(sda, 1);
        else
            IOWR_ALTERA_AVALON_PIO_DATA(sda, 0);

        mask >>= 1;
        IOWR_ALTERA_AVALON_PIO_DATA(scl, 1);
        ::usleep(1);
        IOWR_ALTERA_AVALON_PIO_DATA(scl, 0);
        ::usleep(1);
    }
    
    IOWR_ALTERA_AVALON_PIO_DIRECTION(sda, 0);
    IOWR_ALTERA_AVALON_PIO_DATA(scl, 1);
    ::usleep(1);
    IOWR_ALTERA_AVALON_PIO_DATA(scl, 0);
    ::usleep(1);
    return 0;
}



