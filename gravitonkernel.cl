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

	DistributeCalculations(globalData, matrix, rrtStacks);
}