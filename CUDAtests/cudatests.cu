#include <iostream>


// Kernel de test
__global__ void Testf(int Tab[], int *casesperthread)
{
	int Pos = blockIdx.x * blockDim.x + threadIdx.x;

	for(int i = Pos * *casesperthread; i < (Pos * *casesperthread) + *casesperthread; i++)
		Tab[i] = i;
}

int main()
{
	// Declarations
	int			blocks = 14,
				threads = 32,
				casesperthread = 400000,
				vsize = blocks * threads * casesperthread;
	
	int *d_casesperthread = &casesperthread;
	
	// CPU allocation block
	int *h_Tab = (int*)malloc(vsize * sizeof(int)),
		*d_Tab;

	// CUDA allocation block
	cudaMalloc((void**)&d_Tab, vsize * sizeof(int));
	cudaMalloc((void**)&d_casesperthread, sizeof(int));

	cudaMemcpy(d_Tab, h_Tab, vsize * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_casesperthread, &casesperthread, sizeof(int), cudaMemcpyHostToDevice);

	// Kernel invocation (448 threads)
	Testf <<<blocks, threads>>> (d_Tab, d_casesperthread);

	// CUDA free block
	//cudaMemcpy(h_Tab, d_Tab, vsize * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(d_Tab);
	cudaFree(d_casesperthread);
	
	// CPU free block
	free(h_Tab);

	return 0;
}