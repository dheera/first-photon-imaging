FIRST-PHOTON IMAGING

    

Ahmed Kirmani, Dheera Venkatraman, Dongeek Shin, Andrea Colaco

Franco N. C. Wong, Jeffrey H. Shapiro, Vivek K Goyal

Research Laboratory of Electronics, Massachusetts Institute of Technology


Paper:
Science 3 January 2014: 343 (6166), 58-61.Published online 29 November 2013
***************************************************************************

(C) All copyrights to the code and data belong to the authors listed above.
The code and data provided is intended for personal use only and cannot be 
used for commercial purposes. The code and data cannot be redistributed 
without permission from the authors. Any modifications to the code should
not delete this notice.




files:
    
first_photon_imaging.m
    
get_road.m
    
averager.m
    
README.txt
    
modified version of SPIRAL toolbox 




* * *  first_photon_imaging.m  * * *



Our main file first_photon_imaging.m
    

1. calls and interprets raw first photon dataset
    
2. performs maximum likelihood (ML) estimation to naively recover scene depth and intensity using the first photon dataset
    
3. performs First-Photon Imaging (FPI)
 reconstruction       
	3.1 intensity estimation 
        
	3.2 noisy pixel censoring
        
	3.3 depth estimation
    
to generate high quality depth and intensity images
.


One can simply execute the .m file by writing



>> first_photon_imaging



in the MATLAB command window. 

On the other hand, the user may choose to execute different parts of the code separately, since the code in first_photon_imaging.m 
is separated in sections. Also, in steps 3.1 and 3.3, we solve the convex optimization problems by 
modifying the Sparse Poisson Intensity Reconstruction ALgrotihms (SPIRAL)
toolbox, released by Zachary T. Harmany, Roummel F. Marcia, and Rebecca M. Willett.
 The original SPIRAL toolbox only allows the minimization of 
standard negative log-likelihood functions (e.g. Poisson)
regularized with various choices of penalty. We have modified the SPIRAL code
 and created SPIRALTAP_modified.m, which enables the minimization of  
log-likelihood terms that are unique to our first photon imaging framework.




* * *  get_road.m  * * *



get_road.m is a function that computes the ROAD statistics of an input image.




* * *  averager.m  * * *



averager.m is used to fill in censored pixels 
by neighborhood averaging in order to generate a good initial starting point 
for our convex depth estimation problem.





