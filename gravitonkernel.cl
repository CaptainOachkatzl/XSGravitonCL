#include "Calculation.cl"

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

	struct GlobalData globalData;
	globalData.threadID = get_local_id(0);
	globalData.planetData = planetData;
	globalData.planetCount = planetCount;
	globalData.simSpeed = simSpeed;
	globalData.elapsedTime = elapsedTime;

	struct RRTStacks rrtStacks = SplitPlanetsIntoStacks(&heap, planetCount, cores);

	CalculateInternally(globalData, rrtStacks.stacks[0]);

	// struct Planet planet = PlanetFromIndexedData(planetData, threadID);
	// planet.pos->x = 1;
	// planet.pos->y = 2;
	// planet.dir->x = 3;
	// planet.dir->y = 4;
	// *planet.mass = 5;

	// heapStart[0] = 112;

	// planet.pos->x = (float)(int)heapStart;
	// planet.pos->y = (float)(int)heap.start;
	// planet.dir->x = (float)heapStart[0];
	// planet.dir->y = (float)*heap.start;

	// 

	// *planet.mass = (float)rrtStacks.stacks[0].size;

	// *planet.mass = (float)(int)get_group_id(0);

	// calculation magic here
}