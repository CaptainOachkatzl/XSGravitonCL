struct PlanetData
{
	__constant float2 * pos;
	__global float2 * dir;
	__constant float * mass;
	int planetCount;
	float elapsedTime;
	float simSpeed;
};

struct PlanetData CreatePlanetData(
	__constant float2 * pos,
	__global float2 * dir,
	__constant float * mass,
	int planetCount,
	float elapsedTime,
	float simSpeed)
{
	struct PlanetData data;
	data.pos = pos;
	data.dir = dir;
	data.mass = mass;
	data.planetCount = planetCount;
	data.elapsedTime = elapsedTime;
	data.simSpeed = simSpeed;

	return data;
}

struct Planet
{

};
