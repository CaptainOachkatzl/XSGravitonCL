struct GlobalData
{
    uint threadID;
    __global float * planetData;
    int planetCount;
    float simSpeed;
    float elapsedTime;
    __global int * debugCounter;
};

struct GlobalData GlobalData_ctor(
    uint threadID,
    __global float * planetData,
    int planetCount,
    float simSpeed,
    float elapsedTime,
    __global int * debugCounter)
{
    struct GlobalData globalData;
	globalData.threadID = threadID;
	globalData.planetData = planetData;
	globalData.planetCount = planetCount;
	globalData.simSpeed = simSpeed;
	globalData.elapsedTime = elapsedTime;
    globalData.debugCounter = debugCounter;

    return globalData;
}

void Debug(struct GlobalData * data, float value)
{
    data->planetData[atomic_inc(data->debugCounter)] = value;
}