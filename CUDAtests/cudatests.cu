#include <iostream>

//	This code sample isn't very useful, it writes the position of the cell for each cell in the table.
//
//	SUMARRY :
//
//	This sample was made to be as simple as possible.
//
//	Variable names :			- h_(varname)		= HOST (CPU) variable
//								- d_(varname)		= DEVICE (GPU) variable
//								- no prefix			= Local variables (They are not transferred between the CPU and the GPU inside the block)
//
//	CUDA variables/functions :	- blockIdx			= vec3 struct gives you the position of the block the kernel runs in
//								- threadIdx			= vec3 struct gives you the position of the thread inside the block the kernel runs in
//								- cudaMalloc()		= Simillar to malloc(), but allocs memory on the graphics card
//								- cudaMemCpy()		= Used to copy content from GPU to CPU and vice versa
//

//	Kernel
__global__ void Testf(int Tab[], int *casesperthread)
{
	int Pos = blockIdx.x * blockDim.x + threadIdx.x;

	for(int i = Pos * *casesperthread; i < (Pos * *casesperthread) + *casesperthread; i++)
		Tab[i] = i;
}

//	Main
int main()
{
	//	Declarations
	int			blocks = 14,
				threads = 32,
				h_casesperthread = 400000,
				vsize = blocks * threads * h_casesperthread;

	//	Declarating casesperthread for the GPU
	int			*d_casesperthread = &h_casesperthread;
	
	//	Matrix allocation and declaration block
	int *h_Tab = (int*)malloc(vsize * sizeof(int)),
		*d_Tab;

	//	CUDA allocation block
	cudaMalloc((void**)&d_Tab, vsize * sizeof(int));
	cudaMalloc((void**)&d_casesperthread, sizeof(int));

	cudaMemcpy(d_Tab, h_Tab, vsize * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_casesperthread, &casesperthread, sizeof(int), cudaMemcpyHostToDevice);

	//	Kernel invocation (448 threads)
	Testf <<<blocks, threads>>> (d_Tab, d_casesperthread);

	//	CUDA free block
	cudaMemcpy(h_Tab, d_Tab, vsize * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(d_Tab);
	cudaFree(d_casesperthread);
	
	//	CPU free block
	free(h_Tab);

	return 0;
}