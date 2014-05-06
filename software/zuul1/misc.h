/*
Jasper ter Weeme
Alex Aalbertsberg
*/

#ifndef _MISC_H_
#define _MISC_H_

#include <stdint.h>

class Observer
{
public:
    virtual void update() = 0;
};

class InfraRood
{
public:
    static InfraRood *getInstance();
    void setObserver(Observer *);
    void init(volatile uint32_t *base, int irq, int ctl);
private:
    InfraRood() { }
    Observer *observer;
    void isr(void *context);
    static void isrBridge(void *context);
    volatile uint32_t *base;
};

class JtagUart
{
public:
    static JtagUart *getInstance();
    void init(volatile uint32_t *base);
    void puts(const char *);
};

class Uart
{
public:
    static Uart *getInstance();
    void init(volatile uint32_t *base);
    void putc(const char);
    void puts(const char *);
private:
    Uart() { }
    volatile uint32_t *base;
};
#endif

