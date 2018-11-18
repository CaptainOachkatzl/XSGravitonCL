#include "RTTMatrix.cl"
#include "Planet.cl"

 void Gravity(
 	__global float2 * out_dir1,
 	__global float2 * out_dir2,
 	__constant float2 * pos1, float mass1,
 	__constant float2 * pos2, float mass2,
 	float simSpeed, float elapsedTime)
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

__kernel void Calculate(
	__local int * in_matrix,
	int steps,
	int cores,
	__local float2 * pos,
	__local float2 * dir,
	__local float * mass,
	int planetCount,
	float elapsedTime,
	float simSpeed)
{
	struct RRTMatrix matrix = CreateRRTMatrix(in_matrix, steps, cores);
	struct PlanetData data = CreatePlanetData(pos, dir, mass, planetCount, elapsedTime, simSpeed);

	// calculation magic here
}