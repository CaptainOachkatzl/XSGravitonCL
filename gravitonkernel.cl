#include "Distribution.cl"

void ApplyAcceleration(struct GlobalData * data)
{
	for(int i = 0; i < data->planetCount; i++)
	{
		__global float2 * pos = GetPosition(data->planetData, i);
		float2 nextFrame = GetDirectionNextFrame(data, i);
		*pos += nextFrame;
	}
}

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

	if(globalData.threadID == 0)
	{
		ApplyAcceleration(&globalData);
	}
}