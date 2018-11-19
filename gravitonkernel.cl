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

	uint threadID = get_local_id(0);

	struct RRTMatrix matrix = CreateRRTMatrix(in_matrix, steps, cores);

	struct Planet planet = PlanetFromIndexedData(planetData, threadID);
	planet.pos->x = 1;
	planet.pos->y = 2;
	planet.dir->x = 3;
	planet.dir->y = 4;
	*planet.mass = 5;

	// heapStart[0] = 112;

	// planet.pos->x = (float)(int)heapStart;
	// planet.pos->y = (float)(int)heap.start;
	// planet.dir->x = (float)heapStart[0];
	// planet.dir->y = (float)*heap.start;

	// struct RRTStacks rrtStacks = SplitPlanetsIntoStacks(&heap, planetCount, cores);

	// *planet.mass = (float)rrtStacks.stacks[0].size;

	// *planet.mass = (float)(int)get_group_id(0);

	// calculation magic here
}