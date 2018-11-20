struct GlobalData
{
    int debugCounter;
    uint threadID;
    __global float * planetData;
    int planetCount;
    float simSpeed;
    float elapsedTime;
};

struct GlobalData GlobalData_ctor(
    uint threadID,
    __global float * planetData,
    int planetCount,
    float simSpeed,
    float elapsedTime)
{
    struct GlobalData globalData;
    globalData.debugCounter = 0;
	globalData.threadID = threadID;
	globalData.planetData = planetData;
	globalData.planetCount = planetCount;
	globalData.simSpeed = simSpeed;
	globalData.elapsedTime = elapsedTime;

    return globalData;
}

void Debug(struct GlobalData * data, float value)
{
    data->planetData[data->debugCounter++] = value;
}