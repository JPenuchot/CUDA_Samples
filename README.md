#CUDA Samples

##REQUIREMENTS :

 * Microsoft Visual C++ Express 2010/Visual Studio 2010
 * CUDA enabled device (See list of CUDA devices on Nvidia website)
 * CUDA drivers (Get them on Nvidia website)
 * CUDA GPU Computing SDK 4.0 (Also on Nvidia website)
 * **Brain.**

##INSTALLATION :

 * Install VS2010/VC++ Express 2010
 * Install CUDA GPU Computing SDK 4.0
 * Open the .sln file
 * Press F7 to build the project
 
NB : I couldn't port it to VS2012 with CUDA 5.0 and I couldn't even make a CUDA project with this environment
setting, if someone had this problem and solved it please let me know how.

##WHAT'S IN THE BOX :

###CUDApi

CUDApi is a program that computes an approx value of  Pi using an algorithm similar  to Monte-Carlo algorithm
distributed on the GPU.  The algorithm is scalable but not dinamically scaled. It is a good way to understand
how GPU computing works (Allocation, multi-threading). I recommend you to use the profiler to have an idea of
the performance gain.

###CPUpi

CPUpi is exactly the  same program  than CUDApi but as a linear algorithm  and running on CPU instead of GPU.
It could be simplified and optimized but the scope of this program was  to make  the  comparison between  two
versions of the same algorithm, but the problem  is  that the memory allocation takes too much cycles and the
profiling tests may not be as exact as I wanted.

###CPUref & CUDAtests

These are some projects to make some tests. You  can use  them  to  make your own programs.  CUDAtests is
already configured so you can easily make your CUDA project without any problem.