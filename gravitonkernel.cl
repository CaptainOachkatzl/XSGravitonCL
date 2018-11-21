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

void ApplyAcceleration(struct ProgramData * programData, struct GlobalData * data, struct RRTStacks * rrtStacks)
{
	ApplyStackAcceleration(data, &rrtStacks->stacks[programData->threadID]);
	ApplyStackAcceleration(data, &rrtStacks->stacks[programData->threadID + (rrtStacks->count / 2)]);
}

__kernel void Calculate(
	__global int * in_matrix,
	__global float * global_planetData,
	__local int * matrix,
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

	struct ProgramData programData = ProgramData_ctor(get_local_id(0), get_local_size(0));

	programData.debugOutput = global_planetData;

	if(programData.threadID == 0)
	{
		for(int i = 0; i < (steps * cores * 2); i++)
			matrix[i] = in_matrix[i];

		for(int i = 0; i < planetCount * PLANET_DATA_SIZE; i++)
			planetData[i] = global_planetData[i];
	}

	Synchronize();
	// CopyPlanetDataToLocal(programData.threadID, programData.workgroupSize, global_planetData, planetData, 0, planetCount * PLANET_DATA_SIZE);
	// CopyMatrixToLocal(programData.threadID, programData.workgroupSize, in_matrix, matrix, 0, steps * cores * 2);

	// Debug(&programData, steps * cores * 2);
	// Debug(&programData, planetCount * PLANET_DATA_SIZE);
	// Debug(global_planetData, &debugCounter, programData.threadID);
	// Debug(global_planetData, &debugCounter, programData.workgroupSize);

	// create data structures
	struct GlobalData globalData = GlobalData_ctor(planetData, planetCount, simSpeed, elapsedTime);
	struct RRTMatrix rrtMatrix = RRTMatrix_ctor(matrix, steps, cores);
	struct RRTStacks rrtStacks = SplitPlanetsIntoStacks(&heap, planetCount, cores);

	// do the gravity calculations
	DistributeCalculations(&programData, &globalData, &rrtMatrix, &rrtStacks, GRAVITY_FUNCTION_ID);
	// do the collision calculations
	DistributeCalculations(&programData, &globalData, &rrtMatrix, &rrtStacks, COLLISION_FUNCTION_ID);

	ApplyAcceleration(&programData, &globalData, &rrtStacks);

	//CopyToOutput(programData.threadID, programData.workgroupSize, planetData, global_planetData, planetCount * PLANET_DATA_SIZE);

	
	if(programData.threadID == 0)
	{
		for(int i = 0; i < planetCount * PLANET_DATA_SIZE; i++)
			global_planetData[i] = planetData[i];
	}

	// for(int i = 0; i < (steps * cores * 2); i++)
	// 	global_planetData[i] = matrix[i];
}