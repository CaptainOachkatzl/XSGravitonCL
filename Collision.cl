#include "Planet.cl"

#define COLLISION_FUNCTION_ID 1

bool IsColliding(struct GlobalData * data, int planet1, int planet2, float2 * out_distanceVector)
{
    *out_distanceVector = *GetPosition(data->planetData, planet2) - *GetPosition(data->planetData, planet1);
    float distance = length(*out_distanceVector);

    float2 coveredDistance = GetDirectionNextFrame(data, planet2) - GetDirectionNextFrame(data, planet1);
    float skalar = dot(coveredDistance, *out_distanceVector);
    float movementDistance = skalar / distance;

    float totalDistance = distance + movementDistance;

    return (*GetRadius(data->planetData, planet1) + *GetRadius(data->planetData, planet2)) >= totalDistance;
}

void CalculateCollisionReaction(struct GlobalData * data, int planet1, int planet2, float2 distanceVector)
{
    __local float2 * dir1 = GetDirection(data->planetData, planet1);
    __local float2 * dir2 = GetDirection(data->planetData, planet2);
    // Source http://www.gamasutra.com/view/feature/131424/pool_hall_lessons_fast_accurate_.php?page=3

    // First, find the normalized vector n from the center of 
    // circle1 to the center of circle2
    distanceVector = normalize(distanceVector);
    // Find the length of the component of each of the movement
    // vectors along n. 
    // a1 = v1 . n
    // a2 = v2 . n
    float acceleration1 = dot(*dir1, distanceVector); // v1.dot(n);
    float acceleration2 = dot(*dir2, distanceVector);

    // Using the optimized version, 
    // optimizedP =  2(a1 - a2)
    //              -----------
    //                m1 + m2
    float mass1 = *GetMass(data->planetData, planet1);
    float mass2 = *GetMass(data->planetData, planet2);
    float2 optimizedP = (2 * (acceleration1 - acceleration2)) / (mass1 + mass2) * distanceVector;

    // v1' = v1 - optimizedP * m2 * n
    *dir1 -= optimizedP * mass2;

    // v2' = v2 + optimizedP * m1 * n
    *dir2 += optimizedP * mass1;
}

void CalculatePairCollision(struct GlobalData * data, int i, int j)
{
    float2 distanceVector;

    if (!IsColliding(data, i, j, &distanceVector))
        return;

    CalculateCollisionReaction(data, i, j, distanceVector);
}