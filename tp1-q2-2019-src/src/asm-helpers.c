#include "builders.h"
#include "ant_engine.h"

void 
doPanic(char *s, orientation_t o)
{
  panic(s);
}

void 
adjust_asm(uint32_t* oldPosition, uint32_t newPosition, uint32_t limit)
{
  adjust(oldPosition, newPosition, limit);
}