struct GlobalData
{
    uint threadID;
    __local float * planetData;
    int planetCount;
    float simSpeed;
    float elapsedTime;
};

struct GlobalData GlobalData_ctor(
    uint threadID,
    __local float * planetData,
    int planetCount,
    float simSpeed,
    float elapsedTime)
{
    struct GlobalData globalData;
	globalData.threadID = threadID;
	globalData.planetData = planetData;
	globalData.planetCount = planetCount;
	globalData.simSpeed = simSpeed;
	globalData.elapsedTime = elapsedTime;

    return globalData;
}

struct ProgramData
{
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
{
void Debug(__global float * output, int * debugCounter, float value)
{
    //data->planetData[atomic_inc(data->debugCounter)] = value;
}