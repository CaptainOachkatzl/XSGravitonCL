#define PLANET_DATA_SIZE 6 // this should be 5 but data allignment is a b*tch

struct Planet
{
	__global float2 * pos;
	__global float2 * dir;
	__global float * mass;
	__global float * radius;
};

struct Planet Planet_ctor(
	__global float2 * pos,
	__global float2 * dir,
	__global float * mass,
	__global float * radius)
{
	struct Planet data;
	data.pos = pos;
	data.dir = dir;
	data.mass = mass;
	data.radius = radius;

	return data;
}

__global float2 * GetPosition(__global float * planetData, int index)
{
	return (__global float2 *) &planetData[index * PLANET_DATA_SIZE];
}

__global float2 * GetDirection(__global float * planetData, int index)
{
	return (__global float2 *) &planetData[(index * PLANET_DATA_SIZE) + 2];
}

__global float * GetMass(__global float * planetData, int index)
{
	return (__global float *) &planetData[(index * PLANET_DATA_SIZE) + 4];
}

__global float * GetRadius(__global float * planetData, int index)
{
	return (__global float *) &planetData[(index * PLANET_DATA_SIZE) + 5];
}

float2 GetDirectionNextFrame(struct GlobalData * data, int index)
{
    return (*GetDirection(data->planetData, index)) * data->simSpeed * data->elapsedTime;
}


struct Planet PlanetFromIndexedData(__global float * planetData, int index)
{
	struct Planet data;
	data.pos = GetPosition(planetData, index);
	data.dir = GetDirection(planetData, index);
	data.mass = GetMass(planetData, index);
	data.radius = GetRadius(planetData, index);

	return data;
}
