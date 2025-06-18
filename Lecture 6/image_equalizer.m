clc
clear
close all

Input_Im_RGB = imread('Brain_MRA.jpg');
Input_Im = Input_Im_RGB(:,:,1);

Output_Im = histeq(Input_Im);
imshowpair(Input_Im,Output_Im,'montage')
title('Original vs Equalized');

figure; imhist(Input_Im); title('Input');
figure; imhist(Output_Im); title('Output');


%% ## RGB to YCrCB than equalize
clc
clear
close all
Input_Im_RGB = imread('Fundus_RGB.jpg');
Input_Im_YCrCb = rgb2ycbcr(Input_Im_RGB);

Y = Input_Im_YCrCb(:,:,1);
Cr = Input_Im_YCrCb(:,:,2);
Cb = Input_Im_YCrCb(:,:,3);

Output_Im_Y = histeq(Y);
imshowpair(Y,Output_Im_Y,'montage')

figure
imhist(Y,256)

figure
imhist(Output_Im_Y,256)
Output_Im_YCrCb(:,:,1) = Output_Im_Y(:,:,1);
Output_Im_YCrCb(:,:,2) = Cr(:,:,1);
Output_Im_YCrCb(:,:,3) = Cb(:,:,1);
Output_Im_RGB = ycbcr2rgb(Output_Im_YCrCb);

figure
imshowpair(Input_Im_RGB,Output_Im_RGB,'montage')

%% ## Perfectly flat equalization
clc;
clear;  
close all;

J = double((imread('Fundus_RGB.bmp')))/255; %input RGB image

J_ycc = rgb2ycbcr(J); % Ycbcr
y = J_ycc(:,:,1); % use y to equalize its histogram
y = y + (0.5 - rand(size(y)))./255; %add uniform random noise
N = size(y,1)*size(y,2);

% number of pixels in each of 256 segments
N_p = round(N/256);

%vectorize image
y_v = reshape(y,[1 N]);
[y_s, y_i] = sort(y_v); % sorted value (s) and index (i)
g = 0; % gray level
for i = N_p : N_p : N
    a = y_i(1 + i - N_p : i); % indices of sorted pixels
    %assign same gray level to pixels in a segment
    y_v(a) = g;
    g = g + 1;
end

% reshape to 2D image
y_n = reshape(y_v,[size(y,1), size(y,2)]);
J_ycc(:,:,1) = y_n / 255; % normalize to [0,1] range
I = ycbcr2rgb(J_ycc); %back to rgb

figure
imshowpair(J,I,'montage')
g = 0 : 255;
h = imhist(J_ycc(:,:,1),256);
h = h / sum(h); % uniform histogram
c = cumsum(h); % comulative
figure(2); bar(g, h);
figure(3); plot(g, c);

%% ## RGB to YCrCB than equalize
clc
clear
close all
Input_Im_RGB = imread('Fundus_RGB.jpg');
Input_Im_hsi = rgb2hsi(Input_Im_RGB);

Y = Input_Im_hsi(:,:,1);
Cr = Input_Im_hsi(:,:,2);
Cb = Input_Im_hsi(:,:,3);

Output_Im_Y = histeq(Y);
imshowpair(Y,Output_Im_Y,'montage')

figure
imhist(Y,256)

figure
imhist(Output_Im_Y,256)
Output_Im_YCrCb(:,:,1) = Output_Im_Y(:,:,1);
Output_Im_YCrCb(:,:,2) = Cr(:,:,1);
Output_Im_YCrCb(:,:,3) = Cb(:,:,1);
Output_Im_RGB = ycbcr2rgb(Output_Im_YCrCb);

figure
imshowpair(Input_Im_RGB,Output_Im_RGB,'montage')