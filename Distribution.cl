#include "Calculation.cl"
#include "RRTMatrix.cl"
#include "Stack.cl"

void CalculateInternally(struct GlobalData * data, struct Stack stack)
{
    if(stack.size < 2)
        return;

    for(int i = 0; i < stack.size - 1; i++)
    {
        for(int j = i + 1; j < stack.size; j++)
            CalculatePairGravity(data, stack.offset + i, stack.offset + j);
    }
}

void CalculateStackPair(struct GlobalData * data, struct Stack stack1, struct Stack stack2)
{
    for(int i = 0; i < stack1.size; i++)
    {
        for(int j = 0; j < stack2.size; j++)
            CalculatePairGravity(data, stack1.offset + i, stack2.offset + j);
    }
}

void Synchronize()
{
    barrier(CLK_LOCAL_MEM_FENCE);
}

void DistributeCalculations(struct GlobalData * data, struct RRTMatrix * matrix, struct RRTStacks * stacks)
{
    for(int i = 0; i < stacks->count; i++)
        CalculateInternally(data, stacks->stacks[i]);

    for(int step = 0; step < matrix->steps; step++)
    {
        Synchronize();

        struct Stack stack1 = stacks->stacks[GetElementIndex(matrix, step, data->threadID, 0)];
        struct Stack stack2 = stacks->stacks[GetElementIndex(matrix, step, data->threadID, 1)];

        CalculateStackPair(data, stack1, stack2);
    }
}