struct RRTMatrix
{
	__local int * rrtMatrix;
	int steps;
	int cores;
};


struct RRTMatrix CreateRRTMatrix(
	__local int * in_matrix,
	int steps,
	int cores)
{
	struct RRTMatrix matrix;
	matrix.rrtMatrix = in_matrix;
	matrix.steps = steps;
	matrix.cores = cores;

	return matrix;
}