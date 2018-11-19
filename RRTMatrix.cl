struct RRTMatrix
{
	__constant int * rrtMatrix;
	int steps;
	int cores;
};


struct RRTMatrix CreateRRTMatrix(
	__constant int * in_matrix,
	int steps,
	int cores)
{
	struct RRTMatrix matrix;
	matrix.rrtMatrix = in_matrix;
	matrix.steps = steps;
	matrix.cores = cores;

	return matrix;
}

int GetElementIndex(struct RRTMatrix matrix, int step, int core, int id)
{
	return matrix.rrtMatrix[(step * matrix.cores) + (core * 2) + id];
}