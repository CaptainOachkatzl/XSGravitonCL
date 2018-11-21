#include "GlobalData.cl"

#define PLANET_DATA_SIZE 6

struct Planet
{
	__local float2 * pos;
	__local float2 * dir;
	__local float * mass;
	__local float * radius;
};

struct Planet Planet_ctor(
	__local float2 * pos,
	__local float2 * dir,
	__local float * mass,
	__local float * radius)
{
	struct Planet data;
	data.pos = pos;
	data.dir = dir;
	data.mass = mass;
	data.radius = radius;

	return data;
}

__local float2 * GetPosition(__local float * planetData, int index)
{
	return (__local float2 *) &planetData[index * PLANET_DATA_SIZE];
}

__local float2 * GetDirection(__local float * planetData, int index)
{
	return (__local float2 *) &planetData[(index * PLANET_DATA_SIZE) + 2];
}

__local float * GetMass(__local float * planetData, int index)
{
	return (__local float *) &planetData[(index * PLANET_DATA_SIZE) + 4];
}

__local float * GetRadius(__local float * planetData, int index)
{
	return (__local float *) &planetData[(index * PLANET_DATA_SIZE) + 5];
}

float2 GetDirectionNextFrame(struct GlobalData * data, int index)
{
    return (*GetDirection(data->planetData, index)) * data->simSpeed * data->elapsedTime;
}

struct Planet PlanetFromIndexedData(__local float * planetData, int index)
{
	struct Planet data;
	data.pos = GetPosition(planetData, index);
	data.dir = GetDirection(planetData, index);
	data.mass = GetMass(planetData, index);
	data.radius = GetRadius(planetData, index);

	return data;
}
