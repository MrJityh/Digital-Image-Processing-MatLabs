% ## For monochrome images : l=f(x,y)
%     - l_min < l < l_max
%     - l_min >= 0 (non-negative)
%     - l_max should be finite
%
%     - The interval [l_min, l_max] is called the intensity or gray scale
%     - Practically, the gray scale is from 0 to L-1, where L is the # of
%       gray levels
%       - 0 -> black
%       - L-1 -> white
%     - Common practice, the gray scale Ε[0 to 1]
%
% ## For Normalization of Values
%     - normal_value = (value - min)/(max - min)
%
% ## Properties of Digital Images
%       - Dynamic Range : [0, L-1]
%       - Saturation is the highest value beyond which all intensity values
%       are clipped
%       - Noise appears as a grainy texture pattern
%       - Contrast is the difference between the highest and lowest
%       intensity levels (Imax = Imin)
% 
% ## MatLab Assistance
%       - 
%
%
%
% ## Sample code for generating RGB pixels
%%
clc
clear

A=zeros(3,3,3);

A(:,:,1)=[255 0 0; 0 0 0; 0 0 0];
A(:,:,2)=[0 0 0; 0 255 0; 0 0 0];
A(:,:,3)=[0 0 0; 0 0 0; 0 0 255];

imshow(A, [])
%%
%
% ## Tutorial Code for Image Histogram
clc
clear
close all

Image2 = [10 255 255 255 10;
    10 128 128 128 10;
    200 200 200 200 200;
    64 128 128 128 64;
    64 0 0 0 64 ];

imshow(Image2)

figure
imshow(Image2, [])

figure
imshow(Image2, [10 128])


Image2=uint8(Image2);
figure

imhist(Image2)

h1=imhist(Image2);


%close all