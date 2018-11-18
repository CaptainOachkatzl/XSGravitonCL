struct RRTMatrix
{
	__local int * _rrtMatrix;
	int _steps;
	int _cores;
};


struct RRTMatrix CreateRRTMatrix(
	__local int * in_matrix,
	int steps,
	int cores)
{
	struct RRTMatrix matrix;
	matrix._rrtMatrix = in_matrix;
	matrix._steps = steps;
	matrix._cores = cores;

	return matrix;
}