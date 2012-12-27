#include <iostream>


// Algo de test
void Testf(int Tab[], int Pos, int cases)
{	
	for(int i = Pos * cases; i < (Pos * cases) + cases; i++)
		Tab[i] = i;
}

int main() {

	// Déclarations et alloc
	int cases = 400000;
	int *Tab = (int*)malloc(488 * cases * sizeof(int));

	// Lancement de la fonction (1 thread, linéaire)
	for(int i = 0; i < 448; i++)
		Testf(Tab, i, cases);
	
	free(Tab);

	return 0;
}