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

function I_new = averager(I,ind,numpix)

% averager.m

% average the neighboring pixels contributing to the ROAD statistics
% to generate a good starting solution for our convex optimization program


% input:
%   I - image
%   ind - ROAD statistics 
%   numpix - size of the image

% output:
%   I_new - filtered image based on ROAD statistics



I_new = I;
[i_grid, j_grid] = find(ind);
indx = [i_grid j_grid]';
for inds = indx
    i = inds(1);
    j = inds(2);
    if( ((i==1) + (i==numpix) + (j==1) + (j==numpix)) > 0 )
        continue;
    end
    neighbor_pixels = I(i-1:i+1,j-1:j+1);
    absval = abs(neighbor_pixels-I(i,j));
    [vals sort_ind] = sort(absval(:));
    for_sort = neighbor_pixels(:);
    best_neighbors = for_sort(sort_ind);
    I_new(i,j) = mean(best_neighbors(5:8));   
    % average    
end



end

