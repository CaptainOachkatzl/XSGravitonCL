struct Planet
{
	__global float2 * pos;
	__global float2 * dir;
	__global float * mass;
};

struct Planet Planet_ctor(
	__global float2 * pos,
	__global float2 * dir,
	__global float * mass)
{
	struct Planet data;
	data.pos = pos;
	data.dir = dir;
	data.mass = mass;

	return data;
}

struct Planet PlanetFromIndexedData(__global float * planetData, int index)
{
	struct Planet data;
	data.pos = (__global float2 *) &planetData[index * 5];
	data.dir = (__global float2 *) &planetData[(index * 5) + 2];
	data.mass = &planetData[(index * 5) + 4];

	return data;
}
