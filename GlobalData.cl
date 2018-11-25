#define PLANET_DATA_SIZE 6

struct GlobalData
{
    __global float * planetData;
    int planetCount;
    float simSpeed;
    float elapsedTime;
};

struct GlobalData GlobalData_ctor(
    __global float * planetData,
    int planetCount,
    float simSpeed,
    float elapsedTime)
{
    struct GlobalData globalData;
	globalData.planetData = planetData;
	globalData.planetCount = planetCount;
	globalData.simSpeed = simSpeed;
	globalData.elapsedTime = elapsedTime;

    return globalData;
}

struct ProgramData
{
    __global float * debugOutput;
    int debugCounter;
    int threadID;
    int workgroupSize;
};

struct ProgramData ProgramData_ctor(int threadID, int workgroupSize)
{
    struct ProgramData data;
    data.debugCounter = 0;
    data.threadID = threadID;
    data.workgroupSize = workgroupSize;

    return data;
}

void Debug(struct ProgramData * data, float value)
{
    //data->planetData[atomic_inc(data->debugCounter)] = value;
    data->debugOutput[data->debugCounter] = value;
    data->debugCounter++;
}