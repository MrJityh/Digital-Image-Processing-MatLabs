%% Opening?
clear; clc; close all

Input_Im_RGB = double(imread('HDCT_Binary.bmp'));
Input_Im = Input_Im_RGB(:,:,1);

Mask = ones(9,9);
Output_Im = imopen (Input_Im ,Mask);

figure; imshowpair(Input_Im,Output_Im,'montage'); title('Opening');

%% CLosing?
clear; clc; close all
Input_Im_RGB = double(imread('Lung_Binary_Inv.bmp'));
Input_Im = Input_Im_RGB(:,:,1);

Mask = ones(9,9);
Output_Im = imclose (Input_Im ,Mask);

figure; imshowpair(Input_Im,Output_Im,'montage'); title('Closed');