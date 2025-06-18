close all;
clc
clear all;
% Read the original image
original_img = imread('HDCT_Image.jpg'); % Replace 'example_image.jpg' with the actual image file
original_img = rgb2gray(original_img); % Convert to grayscale if it's a color image
original_img = im2double(original_img); % Normalize the image

% Add periodic noise to the image
[M, N] = size(original_img);
[X, Y] = meshgrid(1:N, 1:M);
frequency = 150; % Frequency in cycles/inch
noise = 0.5 * sin(2 * pi * frequency * X / N);
noisy_img = original_img + noise;

% Define the parameters for the Gaussian bandpass filter
D0 = [100,120,150]; % Central frequencies
W = 20; % Bandwidth

filtered_imgs = cell(1, length(D0));

for i = 1:length(D0)
    % Create frequency-domain coordinates
   
    [U, V] = meshgrid(-(N/2):(N/2-1), -(M/2):(M/2-1)); 
    D = sqrt(U.^2 + V.^2);
    
    % Construct Gaussian bandpass filter using the provided equation
    H_BP = (exp(-0.5 * ((D.^2 - D0(i)^2) ./ (D .* W)).^2));
    imshow(H_BP)
    % Apply the filter in the frequency domain
    noisy_img_fft = fftshift(fft2(noisy_img));   % Fourie transform of the Image is shifted to have the same center like the BPF
    filtered_img_fft = H_BP .* noisy_img_fft;
    filtered_img = real(ifft2(ifftshift(filtered_img_fft)));
    filtered_imgs{i} = noisy_img-filtered_img;   % This to make it a band reject filter
end

% Display results
figure;
subplot(2, 3, 1);
imshow(original_img, []);
title('Original Image');

subplot(2, 3, 2);
imshow(noise, []);
title('Periodic Noise');

subplot(2, 3, 3);
imshow(noisy_img, []);
title('Noisy Image');

for i = 1:length(D0)
    subplot(2, 3, 3 + i);
    imshow(filtered_imgs{i}, []);
    title(['Filtered Image D0 = ' num2str(D0(i))]);
end