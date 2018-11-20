#include "Calculation.cl"
#include "RRTMatrix.cl"
#include "Stack.cl"

void ExecuteFunction(struct GlobalData * data, int i, int j, int functionID)
{
    if(functionID == GRAVITY_FUNCTION_ID)
        CalculatePairGravity(data, i, j);
}

void CalculateInternally(struct GlobalData * data, struct Stack stack, int functionID)
{
    if(stack.size < 2)
        return;

    for(int i = 0; i < stack.size - 1; i++)
    {
        for(int j = i + 1; j < stack.size; j++)
            ExecuteFunction(data, stack.offset + i, stack.offset + j, functionID);
    }
}

void CalculateStackPair(struct GlobalData * data, struct Stack stack1, struct Stack stack2, int functionID)
{
    for(int i = 0; i < stack1.size; i++)
    {
        for(int j = 0; j < stack2.size; j++)
            ExecuteFunction(data, stack1.offset + i, stack2.offset + j, functionID);
    }
}

void Synchronize()
{
    barrier(CLK_LOCAL_MEM_FENCE);
}

void DistributeCalculations(struct GlobalData * data, struct RRTMatrix * matrix, struct RRTStacks * stacks, int functionID)
{
    for(int i = 0; i < stacks->count; i++)
        CalculateInternally(data, stacks->stacks[i], functionID);

    for(int step = 0; step < matrix->steps; step++)
    {
        Synchronize();

        struct Stack stack1 = stacks->stacks[GetElementIndex(matrix, step, data->threadID, 0)];
        struct Stack stack2 = stacks->stacks[GetElementIndex(matrix, step, data->threadID, 1)];

        CalculateStackPair(data, stack1, stack2, functionID);
    }
}