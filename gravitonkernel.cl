#include "RTTMatrix.cl"
#include "Stack.cl"


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
	__constant int * in_matrix,
	int steps,
	int cores,
	__global float * planetData,
	int planetCount,
	float elapsedTime,
	float simSpeed)
{
	uchar heapStart[512];
	struct Heap heap = Heap_ctor(heapStart);

	struct RRTMatrix matrix = CreateRRTMatrix(in_matrix, steps, cores);
	 // Planet_ctor((__global float2 *)&planetData[0], (__global float2 *)&planetData[2], &planetData[4]);
	//struct Planet planet2 = PlanetFromIndexedData(planetData, 1);

	//planetData[9] = 3.5;

		struct Planet planet = PlanetFromIndexedData(planetData, 1);
		planet.pos->x = 1;
		// planet.pos->y = 1;
		// planet.dir->x = 1;
		// planet.dir->y = 1;
		// *planet.mass = 1;

	// for(int i = 0; i < planetCount; i++)
	// {
	// 	struct Planet planet = PlanetFromIndexedData(planetData, i);
	// 	planet.pos->x = i;
	// 	planet.pos->y = i;
	// 	planet.dir->x = i;
	// 	planet.dir->y = i;
	// 	*planet.mass = i;
	// }
		
	// planetData[0] = 2;

	// planet1.pos->y = 0.5;
	// planet2.pos->x = 3.5;

	// calculation magic here
}