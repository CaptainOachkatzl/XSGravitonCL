#include "RRTMatrix.cl"
#include "Planet.cl"
#include "Stack.cl"
#include "GlobalData.cl"

void Gravity(
    __global float2 * out_dir1,
    __global float2 * pos1,
    float mass1,
    __global float2 * out_dir2,
    __global float2 * pos2, 
    float mass2,
    float simSpeed, 
    float elapsedTime)
{
    float2 directionVec = *pos2 - *pos1;

    float dis = length(directionVec);
    if (!dis)
        return;

    dis = dis * dis;

    float acceleration = 0.0000000000000000667408F * simSpeed / dis * elapsedTime;

    directionVec = normalize(directionVec) * acceleration;

    (*out_dir1) += (directionVec * mass2);
    (*out_dir2) -= (directionVec * mass1);
}

void CalculatePair(struct GlobalData * data, int i, int j)
{
    Gravity(
        GetDirection(data->planetData, i),
        GetPosition(data->planetData, i),
        *GetMass(data->planetData, i),
        GetDirection(data->planetData, j),
        GetPosition(data->planetData, j),
        *GetMass(data->planetData, j),
        data->simSpeed,
        data->elapsedTime);
}

void CalculateInternally(struct GlobalData * data, struct Stack stack)
{
    if(stack.size < 2)
        return;

    for(int i = 0; i < stack.size - 1; i++)
    {
        for(int j = i + 1; j < stack.size; j++)
            CalculatePair(data, stack.offset + i, stack.offset + j);
    }
}

void CalculateStackPair(struct GlobalData * data, struct Stack stack1, struct Stack stack2)
{
    for(int i = 0; i < stack1.size; i++)
    {
        for(int j = 0; j < stack2.size; j++)
            CalculatePair(data, stack1.offset + i, stack2.offset + j);
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