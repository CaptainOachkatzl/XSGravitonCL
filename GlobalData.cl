#define PLANET_DATA_SIZE 6

struct GlobalData
{
    __local float * planetData;
    int planetCount;
    float simSpeed;
    float elapsedTime;
};

struct GlobalData GlobalData_ctor(
    __local float * planetData,
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

void CopyPlanetDataToLocal(int threadID, int workgroupSize, __global float * in, __local float * out, int startIndex, int dataSize)
{
    for(int i = startIndex + threadID; i < startIndex + dataSize; i += workgroupSize)
        out[i] = in[i];
}

void CopyMatrixToLocal(int threadID, int workgroupSize, __global int * in, __local int * out, int startIndex, int dataSize)
{
    for(int i = startIndex + threadID; i < startIndex + dataSize; i += workgroupSize)
        out[i] = in[i];
}

void CopyToOutput(int threadID, int workgroupSize, __local float * in, __global float * out, int dataSize)
{
    for(int i = threadID; i < dataSize; i += workgroupSize)
    {
        if(i % PLANET_DATA_SIZE < 4)
            out[i] = in[i];
    }
}

void Debug(struct ProgramData * data, float value)
{
    //data->planetData[atomic_inc(data->debugCounter)] = value;
    data->debugOutput[data->debugCounter] = value;
    data->debugCounter++;
}