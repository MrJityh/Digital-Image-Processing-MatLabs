%% Question 2 - DFT Practice
clc; clear; close all; 

Amp = 120;  
fx = 15;    
fy = 15;    
fsamp = 256;

% Grid
x = linspace(0, 1, fsamp);
y = linspace(0, 1, fsamp);  
[X, Y] = meshgrid(x, y);

% Define the 2D sinusoidal signals
F1 = 40 + Amp * sin(2 * pi * fx * X);
F2 = 40 + Amp * sin(2 * pi * fy * Y); 
F3 = 40 + Amp * sin(2 * pi * fx * X + 2 * pi * fy * Y);

% Compute the 2D DFT (FFT) and shift it to center
DFT1 = fft2(F1); DFT1 = fftshift(DFT1); 
DFT2 = fft2(F2); DFT2 = fftshift(DFT2); 
DFT3 = fft2(F3); DFT3 = fftshift(DFT3); 

% Magnitude of each DFT
mag1 = abs(DFT1); 
mag2 = abs(DFT2); 
mag3 = abs(DFT3); 

% Create u, v frequencies based on the FFT
u = linspace(-fsamp/2, fsamp/2-1, fsamp); 
v = linspace(-fsamp/2, fsamp/2-1, fsamp);
[U, V] = meshgrid(u, v);

% Plot Signal 1, Signal 2, and Signal 3 as 2D images in grayscale
figure; hold on;
subplot(2,3,1); imagesc(F1); title('F1');
axis equal; axis off;

subplot(2,3,2); imagesc(F2); title('F2');
axis equal; axis off;

subplot(2,3,3); imagesc(F3); title('F3');
axis equal; axis off;

% 3D DFT Plots
cb = colorbar('south'); set(cb,'position',[.3 .025 .4 .025]);

subplot(2,3,4); surf(U, V, mag1, 'EdgeColor', 'none');  axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F1'); view(30, 30); 

subplot(2,3,5); surf(U, V, mag2, 'EdgeColor', 'none'); axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F2'); view(30, 30);

subplot(2,3,6); surf(U, V, mag3, 'EdgeColor', 'none');  axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F3'); view(30, 30);

for i=1:3
    colormap(subplot(2,3,i),"gray");
    colormap(subplot(2,3,i+3),"parula");
end
colormap(cb,"parula");

%% Question 3 
clc; clear; close all;
InputRGB = imread('HDCT_Image.jpg');
Input = im2double(rgb2gray(InputRGB));

% Define image size and frequency domain coordinates
[M, N] = size(Input);
f_noise = 150; D01 = 100; D02 = 145; D03 = 150; W = 20;         
[u, v] = meshgrid(-floor(N/2):floor((N-1)/2), -floor(M/2):floor((M-1)/2));
D = sqrt(u.^2 + v.^2);

% Create and add noise
[x, y] = meshgrid(1:N, 1:M);
noise = 0.5*sin(2 * pi * (f_noise) * y / N);
noisyImage = Input + noise;
noisyImage = real(fftshift(fft2(noisyImage)));

% Gaussian bandpass filters
band_pass_filter1 = exp(-0.5 * (((D.^2 - D01^2) ./ (D01 * W)).^2));
band_pass_filter2 = exp(-0.5 * (((D.^2 - D02^2) ./ (D02 * W)).^2));
band_pass_filter3 = exp(-0.5 * (((D.^2 - D03^2) ./ (D03 * W)).^2));

filteredNoisy = noisyImage .* band_pass_filter1;
filteredNoisy1 = real(ifft2(ifftshift(filteredNoisy)));

filteredNoisy = noisyImage .* band_pass_filter2;
filteredNoisy2 = real(ifft2(ifftshift(filteredNoisy)));

filteredNoisy = noisyImage .* band_pass_filter3;
filteredNoisy3 = real(ifft2(ifftshift(filteredNoisy)));

% Display results
figure;
subplot(2, 3, 1), imshow(Input, []), title('Original Image');
subplot(2, 3, 2), imshow(noisyImage, []), title('Periodic Noise');
subplot(2, 3, 4), imshow(filteredNoisy1, []), title('Gauss. Bandpass D0 = 100');
subplot(2, 3, 5), imshow(filteredNoisy2, []), title('Gauss. Bandpass D0 = 145');
subplot(2, 3, 6), imshow(filteredNoisy3, []), title('Gauss. Bandpass D0 = 150');
