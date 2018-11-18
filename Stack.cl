#include "Planet.cl"
#include "Heap.cl"

struct Stack
{
    int size;
    int offset;
};

struct RRTStacks
{
    int count;
    struct Stack * stacks;
};

struct RRTStacks SplitPlanetsIntoStacks(struct Heap * heap, int elementCount, int coreCount)
{
    int stackCount = coreCount * 2;
    int stackSize = elementCount / stackCount;
    int leftover = elementCount % stackCount;

    struct RRTStacks rrtStacks;
    rrtStacks.count = stackCount;
    rrtStacks.stacks = (struct Stack *) malloc(heap, stackCount * sizeof(struct Stack));

    for (int i = 0; i < stackCount; i++)
    {
        // as there might be numbers of parts which are not divideable cleanly
        // the leftovers get added one by one to the first few stacks

        // e.g. 6 parts divided by 4 stacks would mean Stacks[0] and Stacks[1] would hold 2 values 
        // while Stacks[2] and Stacks[3] hold only one
        struct Stack * stack = &rrtStacks.stacks[i];

        if (i < leftover)
        {
            
            stack->size = stackSize + 1;
            stack->offset = i * stackSize + i;
        }
        else
        {
            stack->size = stackSize;
            stack->offset = i * stackSize + leftover;
        }
    }

    return rrtStacks;
}