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

%% first_photon_imaging.m

%
% main code that 
%   1. calls and interprets first photon dataset
%   2. performs naive depth+intensity imaging based on maximum likelihood estimation
%   3. performs first photon depth+intensity imaging in three steps
%       3.1 intensity estimation (requires modified SPIRAL-TAP)
%       3.2 noisy pixel censoring (requires get_road.m , averager.m)
%       3.3 depth estimation (requires modified SPIRAL-TAP)
%

%% 1. call first photon dataset

clear all; close all; clc;

disp('start : call data');

numPixels = 500;
load('photon_dat');
res = 8;


addpath(genpath([pwd '\spiral']))
%addpath(genpath([pwd '/spiral'])) % uncomment for mac

data_NumElapsedPulses_image = reshape(data_NumElapsedPulses, [numPixels numPixels]);
data_TimeofArrival_image = reshape(data_TimeofArrival, [numPixels numPixels]);

% flip every column of image as raster scanned
for ii=1:numPixels
    if(mod(ii,2)==1)
        data_NumElapsedPulses_image(:,ii)=flipud(data_NumElapsedPulses_image(:,ii));
        data_TimeofArrival_image(:,ii)=flipud(data_TimeofArrival_image(:,ii));
    end
end
data_NumElapsedPulses_image = flipud(data_NumElapsedPulses_image);
data_TimeofArrival_image = flipud(data_TimeofArrival_image);

figure; 
subplot(121); imagesc(data_NumElapsedPulses_image); axis image; colorbar;
set(gca,'xtick',[],'ytick',[]); title('data : number of elapsed pulses (counts)');
subplot(122); imagesc(data_TimeofArrival_image); axis image; colorbar;
set(gca,'xtick',[],'ytick',[]); title('data : time-of-arrival (bins)');

colormap('gray'); 

disp('end : call data');


%% 2. maximum likelihood (ML) estimation using the first photon dataset


close all;

disp('start : ML');

c = 3e8; % speed of light
alph = 1/(7e-3);
calibration_offset = 3;
time_to_depth = (8e-12)*c/2;

% maximum likelihood intensity estimate
prob_image = 1./(1+data_NumElapsedPulses_image); % prob of hit;
intensityML_image = -alph*log(1-prob_image);

% maximum likelihood depth estimate
depthML_image = time_to_depth*data_TimeofArrival_image - calibration_offset;



intensity_range = [0 1];
depth_range = [1.2 1.7]; % in meters

figure; 
subplot(121); imagesc(intensityML_image,intensity_range); axis image; colorbar;
set(gca,'xtick',[],'ytick',[]);
subplot(122); imagesc(depthML_image,depth_range); axis image; colorbar;
set(gca,'xtick',[],'ytick',[]);
colormap('gray');
title('data');


disp('end : ML');


%% 3. first photon imaging
%% 3.1 intensity estimation


close all;

disp('start : intensity estimation');

% set wavelet basis
wav = daubcqf(2);
W = @(x) midwt(x,wav);
WT = @(x) mdwt(x,wav);

tau = 0.7; % penalty parameter
ainit = 0.7; % initial descent 
maxiter = 25; % max number of iterations

set_penalty = 'tv';

AT = @(x) x; A = @(x) x;
nMap = []; % no censoring
prob_image = SPIRALTAP_modified(nMap,data_NumElapsedPulses_image,A,tau, ...
    'noisetype','geometric', ...
    'penalty',set_penalty, ...
    'maxiter',maxiter,...
    'Initialization',-log(1-exp(-intensityML_image/alph-0.01)),... 
    'AT',AT,...
    'monotone',1,...
    'miniter',1,...
    'W',W,...
    'WT',WT,...
    'stopcriterion',3,...
    'tolerance',1e-6,...
    'alphainit',ainit,...
    'alphaaccept',1e80,...
    'logepsilon',1e-10,...
    'saveobjective',1,...
    'savereconerror',1,...
    'savecputime',1,...
    'savesolutionpath',0,...
    'truth',zeros(numPixels,numPixels),...
    'verbose',5);
intensityMAP_image = -alph*log(1-exp(-prob_image));

figure; imagesc(intensityMAP_image, intensity_range);
axis image;  set(gca,'xtick',[],'ytick',[]); colorbar;
colormap('gray'); title('intensity estimate (first photon imaging)')

disp('end : intensity estimation');

%% 3.2 noisy pixel detection

close all;

disp('start : pixel censoring');

pulse_dur = 100;

img_filt = data_TimeofArrival_image;
num_ite = 2;
road_mask = zeros(size(img_filt)); % the censored pixel mask
for i=1:num_ite
    R = get_road(img_filt,4,size(img_filt,1));
    road_mask = road_mask | (R>(pulse_dur*4./(1+intensityMAP_image)));
    img_filt = averager(img_filt,R>(pulse_dur*4./(1+intensityMAP_image)),numPixels);
end
depthML_road_image = time_to_depth*img_filt-calibration_offset;

% the good images
figure; imagesc(depthML_road_image,depth_range); 
axis image; set(gca,'xtick',[],'ytick',[]); colorbar;
colormap('gray');

disp('end : pixel censoring');

%% 3.3 depth estimation

close all;

% set wavelet basis
wav = daubcqf(2);
W = @(x) midwt(x,wav);
WT = @(x) mdwt(x,wav);

nMap = road_mask;

tau = 20; 
ainit = 16;

set_penalty = 'tv';
%
maxiter = 20; tolerance = 1e-8; verbose = 2;
AT = @(x) x; A = @(x) x;
tof_image = SPIRALTAP_modified(nMap,img_filt,A,tau, ...
    'noisetype','pulse', ...
    'penalty',set_penalty, ...
    'maxiter',maxiter,...
    'Initialization',img_filt ,...
    'AT',AT,...
    'monotone',1,...
    'miniter',5,...
    'W',W,...
    'WT',WT,...
    'stopcriterion',3,...
    'alphainit',ainit,...
    'tolerance',tolerance,...
    'alphaaccept',1e30,...
    'logepsilon',1e-10,...
    'saveobjective',1,...
    'savereconerror',1,...
    'savecputime',1,...
    'savesolutionpath',0,...
    'truth',zeros(numPixels),...
    'verbose',5);
depthMAP_image = time_to_depth*tof_image-calibration_offset;

figure; imagesc(depthMAP_image, depth_range); 
title('depth estimate (first photon imaging)')
colorbar; axis image; set(gca,'xtick',[],'ytick',[]); colormap('gray'); 

%% plot all imaging results 


figure;
subplot(231); imagesc(data_NumElapsedPulses_image); 
axis image; set(gca,'xtick',[],'ytick',[]); title('data:elapsed counts')
subplot(234); imagesc(data_TimeofArrival_image); 
axis image; set(gca,'xtick',[],'ytick',[]); title('data:time-of-arrival')
subplot(232); imagesc(intensityML_image, intensity_range); 
axis image; set(gca,'xtick',[],'ytick',[]); title('ml intensity imaging')
subplot(235); imagesc(depthML_image, depth_range); 
axis image; set(gca,'xtick',[],'ytick',[]); title('ml depth imaging')
subplot(233); imagesc(intensityMAP_image, intensity_range); 
axis image; set(gca,'xtick',[],'ytick',[]); title('our intensity imaging') 
subplot(236); imagesc(depthMAP_image, depth_range); 
axis image; set(gca,'xtick',[],'ytick',[]); title('our depth imaging')
colormap('gray'); 

%% save data

save('results_save', ...
    'data_NumElapsedPulses_image','data_TimeofArrival_image', ...
    'intensityML_image','depthML_image', ...
    'intensityMAP_image','depthMAP_image')
