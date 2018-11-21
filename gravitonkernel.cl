#include "Distribution.cl"

void ApplyStackAcceleration(struct GlobalData * data, struct Stack * stack)
{
	for(int i = 0; i < stack->size; i++)
	{
		int planetID = i + stack->offset;
		__local float2 * pos = GetPosition(data->planetData, planetID);
		float2 nextFrame = GetDirectionNextFrame(data, planetID);
		*pos += nextFrame;
	}
}

void ApplyAcceleration(struct GlobalData * data, struct RRTStacks * rrtStacks)
{
	ApplyStackAcceleration(data, &rrtStacks->stacks[data->threadID]);
	ApplyStackAcceleration(data, &rrtStacks->stacks[data->threadID + (rrtStacks->count / 2)]);
}

__kernel void Calculate(
	__local int * in_matrix,
	int steps,
	int cores,
	__local float * planetData,
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

	// do the gravity calculations
	DistributeCalculations(&globalData, &matrix, &rrtStacks, GRAVITY_FUNCTION_ID);
	// do the collision calculations
	DistributeCalculations(&globalData, &matrix, &rrtStacks, COLLISION_FUNCTION_ID);

	ApplyAcceleration(&globalData, &rrtStacks);
}