#include "Distribution.cl"

__kernel void Calculate(
	__constant int * in_matrix,
	int steps,
	int cores,
	__global float * planetData,
	int planetCount,
	float elapsedTime,
	float simSpeed,
	__global int * debugCounter)
{
	// initialize heap
	uchar heapStart[1024];
	struct Heap heap = Heap_ctor(heapStart);

	// create data structures
	struct GlobalData globalData = GlobalData_ctor(get_local_id(0), planetData, planetCount, simSpeed, elapsedTime, debugCounter);
	struct RRTMatrix matrix = RRTMatrix_ctor(in_matrix, steps, cores);
	struct RRTStacks rrtStacks = SplitPlanetsIntoStacks(&heap, planetCount, cores);

	// do the gravity calculations
	DistributeCalculations(&globalData, &matrix, &rrtStacks, GRAVITY_FUNCTION_ID);
	// do the collision calculations
	DistributeCalculations(&globalData, &matrix, &rrtStacks, COLLISION_FUNCTION_ID);
}