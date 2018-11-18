struct PlanetData
{
	__local float2 * pos;
	__local float2 * dir;
	__local float * mass;
	int planetCount;
	float elapsedTime;
	float simSpeed;
};

struct PlanetData CreatePlanetData(
	__local float2 * pos,
	__local float2 * dir,
	__local float * mass,
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
