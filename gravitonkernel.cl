#include "Distribution.cl"

__kernel void Calculate(
	__constant int * in_matrix,
	int steps,
	int cores,
	__global float * planetData,
	int planetCount,
	float elapsedTime,
	float simSpeed)
{
	// initialize heap
	uchar heapStart[1024];
	struct Heap heap = Heap_ctor(heapStart);

	// create data structures
	struct GlobalData globalData = GlobalData_ctor(get_local_id(0), planetData, planetCount, simSpeed, elapsedTime);
	struct RRTMatrix matrix = RRTMatrix_ctor(in_matrix, steps, cores);
	struct RRTStacks rrtStacks = SplitPlanetsIntoStacks(&heap, planetCount, cores);

	// do the calculations
	DistributeCalculations(&globalData, &matrix, &rrtStacks);
}