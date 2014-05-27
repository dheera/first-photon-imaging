=============================================================================
=        SPIRAL:  Sparse Poisson Intensity Reconstruction Algorithms        =
=                          README.txt Version 1.0                           =
=============================================================================
=    Copyright 2009, 2010                                                   =
=    Zachary T. Harmany*, Roummel F. Marcia**, Rebecca M. Willett*          =
=        *  Department of Electrical and Computer Engineering               =
=           Duke University                                                 =
=           Durham, NC 27708, USA                                           =
=       **  School of Natural Sciences                                      =
=           University of California, Merced                                =
=           Merced, CA 95343, USA                                           =
=                                                                           =
=    Corresponding Author: Zachary T. Harmany (zth@duke.edu)                =
============================================================================= 

==== Overview ====
The Sparse Poisson Intensity Reconstruction ALgrotihms (SPIRAL) toolbox,
SPIRALTAP.m, is MATLAB code for recovering sparse signals from Poisson
observations. SPIRAL minimizes a regularized negative log-likelihood 
objective function with various penalty choices for the regularization terms:
    - Sparsity (l1 norm) of the coefficients in an orthonormal basis,
    - Total variation seminorm of the image,
    - Penalty based on Recursive Dyadic Partitions (RDPs), and
    - Penalty based on translationally-invariant (cycle-spun) RDPs.

For more details, see
Zachary T. Harmany, Roummel F. Marcia, Rebecca M. Willett, "This is
SPIRAL-TAP: Sparse Poisson Intensity Reconstruction Algorithms -- Theory
and Practice," Submitted to IEEE Transactions on Image Processing.
A preprint of this article is available on arXiv.org:
http://arxiv.org/pdf/1005.4274 

To aid users we provide a few examples of our algorithm. To view a
demonstration, execute in MATLAB

>> SPIRALdemo

the varialbe 'demo' in SPIRALdemo.m to 1, 2, or 3 selects 
among three simulations.  Details of each can be found below.

NOTE:  Some of these demonstrations utilize the Rice Wavelet Toolbox to compute
the discrete wavelet transform.  We include this toolbox here (although it may
need to be recompiled on your platform) and is also freely available online:
http://dsp.rice.edu/software/rice-wavelet-toolbox 
We also use the FISTA algorithm of Beck and Teboulle for constrained Total 
Variation denoising.  This toolbox is in the 'denoise' directory and is also
available online:
http://ie.technion.ac.il/~becka/papers/tv_fista.zip

==== Demonstration 1 ====
Description:  One dimensional compressed sensing example penalizing the 
    sparsity (l1 norm) of the coefficients in the canonical basis.  Here the
    true signal f is of length 100,000 with 1,500 nonzero entries yielding a 
    sparsity of 1.5%.  We take 40,000 compressive measurements in y. The 
    average number of photons per measurement is 15.03, with a maximum of 145.
    We run SPIRAL until the relative change in the iterates falls below
    a tolerance of 1x10^-8, up to a maximum of 100 iterations (however only 
    37 iterations are required to satisfy the stopping criterion).  

Output:  This demonstration automatically displays the following:
    Figure 1:   Simulation setup (true signal, true detector intensity, 
                observed counts),
    Figure 2:   Reconstructed signal overlaid on top of the true signal,
    Figure 3:   RMSE error evolution versus iteration and compute time, and
    Figure 4:   Objective evolution versus iteration and compute time.

==== Demonstration 2 ====
Description:  Here we consider an image deblurring example.  The true signal 
    is a 128x128 Shepp-Logan phantom image with mean intensity 1.22x10^5.  The
    true detector mean intensity is 45.8, and the observed photon count mean
    is 45.8 with a maximum of 398.  Here we consider four penalization methods
	- Sparsity (l1 norm) of coefficients in an orthonormal (wavelet) basis,
    - Total variation of the image,
    - Penalty based on Recursive Dyadic Partitions (RDPs), and
    - Penalty based on Translationally-Invariant (cycle-spun) RDPs.
    We run all the SPIRAL methods for a minimum of 50 iterations until the 
    relative change in the iterates falls below a tolerance of 1x10^-8, up 
    to a maximum of 100 iterations (however only ~70 iterations are required
    to satisfy the stopping criterion for all the methods).  

Output:  This demonstration automatically displays the following:
	Figure 1:   Simulation setup (true signal, true detector intensity, 
                observed counts),
    Figure 2:   The objective evolution for the methods where explicit 
                computation of the objective is possible,
    Figure 3:   RMSE error evolution versus iteration and compute time,
    Figure 4:   The final reconstructions, and
    Figure 5:   The magnitude of the errors between the final 
                reconstructions and the true phantom image. 

==== Demonstration 3 ====
Description:  This demonstration is similar to Demonstration 2, but uses the
    256x256 'Cameraman' image instead of the 128x128 Shepp-Logan phantom.  The
    true signal has a mean intensity of 1.19x10^5, the true detector mean 
    intensity is 44.4, and the observed photon count mean is 44.4 with a
    maximum of 111.  Due to the larger problem size, we need to alter the 
    termination criteria.  We run all the SPIRAL methods for a minimum of
    50 iterations until the relative change in the iterates falls below a
    tolerance of 1x10^-8, up to a maximum of 300 iterations.

Output:  Like Demonstration 2, this demonstration automatically displays
    the following:
	Figure 1:   Simulation setup (true signal, true detector intensity, 
                observed counts),
    Figure 2:   The objective evolution for the methods where explicit 
                computation of the objective is possible,
    Figure 3:   RMSE error evolution versus iteration and compute time,
    Figure 4:   The final reconstructions, and
    Figure 5:   The magnitude of the errors between the final 
                reconstructions and the true phantom image. 

Copyright (2010): Zachary T. Harmany, Roummel F. Marcia, and Rebecca M. Willett


