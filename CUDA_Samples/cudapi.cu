#include <iostream>

//	Virtual grid dimensions :
//
//	20 000 * 20 000
//	20 blocks, 20 threads
//	2 000 cells/thread
//
//	Matrix dimensions :
//	
//	20*20 Matrix
//	Virtualized as a 400 cells array (20 * 20)
//	Each cell of the matrix has 2 000 virtual cells
//
//	Algorithm used to get a position into the thread grid :
//
//	Pos = blockIdx.x * blockDim.x + threadIdx.x


//	SUMARRY :
//	
//	Variables names :			- h_(varname)		= HOST (CPU) variable
//								- d_(varname)		= DEVICE (GPU) variable
//								- no prefix			= Local variables (They are not transferred between the CPU and the GPU inside the block)
//
//	Variables/Matrix usage :	- Mat[]				= The sum of each value of each cell of this virtual matrix gives the area of the quarter disk
//								- vCellsPerThread	= Number of virtual cells for each thread (One thread checks for several cells)
//								- MatX/MatY			= Matrix dimensions (Blocks * Threads)
//								- Area				= Sum of each value of each cell of Mat[] after computing
//								- Pi				= Approx value of Pi
//								- SQGridSize		= Stands for Square Grid Size, it is the area of the virtual grid (MatX * MatY * vCellsPerThread * vCellsPerThread)
//								- MatSize			= Size of the 400 cells matrix
//
//	CUDA variables/functions :	- blockIdx			= vec3 struct giving you the position of the block the kernel is located in
//								- threadIdx			= vec3 struct giving you the position of the thread inside the block the kernel is located in
//								- cudaMalloc()		= Simillar to malloc(), but allocs memory on the graphics card
//								- cudaMemCpy()		= Used to copy content from GPU to CPU and vice versa


// This is the kernel running on the GPU. It is pretty basic, it checks for each case if it is inside or outside the quarter disk
__global__ void MatComputing( double Mat[],  int *vCellsPerThread,  int *MatX,  int *MatY) {

	// Getting the position of the kernel and the grid size
	int	Pos = blockIdx.x * blockDim.x + threadIdx.x,
		SQGridSize = *MatX * *MatY * *vCellsPerThread * *vCellsPerThread;

	Mat[Pos] = 0;

	// This tests each cell to know if it is or not inside the quarter disk
	for(double i = blockIdx.x * *vCellsPerThread; i < (blockIdx.x * *vCellsPerThread) + *vCellsPerThread; i++)
		for(double j = threadIdx.x * *vCellsPerThread; j < (threadIdx.x * *vCellsPerThread) + *vCellsPerThread; j++)
			if((i * i) + (j * j) <= SQGridSize)
				Mat[Pos]++;
}

int main() {
	
	// DECLARATIONS AND ALLOCATIONS ON THE GPU
	const  int		h_MatX = 20,
					h_MatY = 20,
					h_vCellsPerThread = 2000;

	const size_t	MatSize = h_MatX * h_MatY * sizeof( double);
					
	double			*h_Mat = ( double*)malloc(MatSize),
					*d_Mat;

	int				*d_MatX = ( int*)malloc(sizeof( int)),
					*d_MatY = ( int*)malloc(sizeof( int)),
					*d_vCellsPerThread;
					

	double			Pi = 0,
					Area = 0;

	cudaMalloc((void**)&d_Mat, MatSize);
	cudaMalloc((void**)&d_vCellsPerThread, sizeof( double));
	cudaMalloc((void**)&d_MatX, sizeof( int));
	cudaMalloc((void**)&d_MatY, sizeof( int));

	cudaMemcpy(d_Mat, h_Mat, MatSize, cudaMemcpyHostToDevice);
	cudaMemcpy(d_vCellsPerThread, &h_vCellsPerThread, sizeof( double), cudaMemcpyHostToDevice);
	cudaMemcpy(d_MatX, &h_MatX, sizeof( int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_MatY, &h_MatY, sizeof( int), cudaMemcpyHostToDevice);

	// MAIN PROGRAM
	MatComputing <<<h_MatX, h_MatY>>> (d_Mat, d_vCellsPerThread, d_MatX, d_MatY);

	cudaMemcpy(h_Mat, d_Mat, MatSize, cudaMemcpyDeviceToHost);

	for(int i = 0; i < h_MatX * h_MatY; i++)
		Area+= h_Mat[i];

	Pi = (Area * 4) / ((h_MatX * h_vCellsPerThread) * (h_MatY * h_vCellsPerThread));

	std::cout << Pi << std::endl;
	std::cin.get();

	// MEMORY DISALLOCATION
	cudaFree(d_Mat);
	cudaFree(d_vCellsPerThread);
	cudaFree(d_MatX);
	cudaFree(d_MatY);

	free(h_Mat);

	return 0;
}