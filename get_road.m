% % FIRST-PHOTON IMAGING
% % 
% % Authors: Ahmed Kirmani, Dheera Venkatraman, Dongeek Shin, Andrea Colaco
% % Franco N. C. Wong, Jeffrey H. Shapiro, Vivek K Goyal
% % 
% % Research Laboratory of Electronics, Massachusetts Institute of Technology
% % 
% % (C) All copyrights to the code and data belong to the authors listed above.
% % The code and data provided is intended for personal use only and cannot be 
% % used for commercial purposes. The code and data cannot be redistributed 
% % without permission from the authors. Any modifications to the code should
% % not delete this notice.

function R = get_road(I,m,num_pix)

% get_road.m

% obtain ROAD statistics of noisy image

% input:
%   I - image
%   m - number of selected neighbors per pixel
%   num_pix - size of the image

% output:
%   R - ROAD statistics of image I

i_grid = 2:(num_pix-1);
j_grid = 2:(num_pix-1);

R = zeros(num_pix,num_pix);
for i=i_grid
    for j=j_grid
        absval = abs(I(i-1:i+1,j-1:j+1)-I(i,j));
        absval_sort = sort(absval(:));
        R(i,j) =  sum(absval_sort(1:(m+1)));
    end
end

end

