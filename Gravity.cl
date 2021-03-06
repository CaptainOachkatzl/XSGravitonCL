#include "Collision.cl"

#define GRAVITY_FUNCTION_ID 0

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

void CalculatePairGravity(struct GlobalData * data, int i, int j)
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