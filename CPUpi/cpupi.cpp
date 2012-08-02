#include <iostream>

// This code simulates the structure of CUDApi as a linear algorithm running on a CPU.

int main() {
	double	Aire = 0,
			Pi = 0;
	
	double	*Tab = (double*)malloc(400 * sizeof(double));
	int		SQGridSize = 20 * 20 * 2000 * 2000;

	for(int i = 0; i < 20; i++)
		for(int j = 0; j < 20; j++) {
			int Pos = i * 20 + j;

				Tab[Pos] = 0;

				for(double x = i * 2000; x < (i * 2000) + 2000; x++)
					for(double y = j * 2000; y < (j * 2000) + 2000; y++)
						if((x * x) + (y * y) <= SQGridSize)
							Tab[Pos]++;
		}

	for(int i = 0; i < 400; i++)
		Aire+= Tab[i];

	Pi = (Aire * 4) / SQGridSize;
	
	std::cout << Pi << std::endl;
	std::cin.get();

	return 0;
}