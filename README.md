#CUDA Samples

##REQUIREMENTS :

 * Microsoft Visual Studio 2010/Visual C++ 2012 (Visual C++ 2010 is free on Microsoft website) or better
 * CUDA enabled device (See list of CUDA devices on Nvidia website)
 * CUDA drivers (Get them on Nvidia website)
 * CUDA GPU Computing SDK (Also on Nvidia website)
 * **Brain.**

##INSTALLATION :

Well, I guess you can open a project and press F7 after you installed all the tools/SDK needed.

##WHAT'S IN THE BOX :

###CUDApi

CUDApi is program that computes an approx value of  Pi using an algorithm similar  to  Monte-Carlo  algorithm
distributed on the GPU.  The algorithm is scalable but not dinamically scaled. It is a good way to understand
how GPU computing works  (Allocation, multi-threading). I recommend you using the profiler to have an idea of
the optimization level.

###CPUpi

CPUpi is exactly the  same program than CUDApi  but  as  a linear algorithm and running on the CPU instead of
the GPU. It could be simplified and optimized but  it wouldn't be the same algorithm than  its GPGPU version.

###CPUref & CUDAtests

These are some projects to make some tests. You  can use  them  to  make your own programs.  CUDAtests is
already configured so you can easily make your CUDA project without any problem.