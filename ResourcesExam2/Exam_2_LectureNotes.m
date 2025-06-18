                        %% Lecture 13 - Discrete Fourier Transform

%% Filtering Using 2D Spatial Convolution
clear; clc; close all
Input_Image_RGB = double(imread('Retina.png'));
Input = (Input_Image_RGB(:,:,1));
f = [-1,-1,-1;-1,9,-1;-1,-1,-1];
Out_Image = fix(conv2(Input, f, 'same'));
[h,w] = size(Out_Image);

for k1=1:h
    for k2=1:w
        if Out_Image(k1,k2)>255
            Out_Image(k1,k2) = 255;
        end
        if Out_Image(k1,k2)<0
            Out_Image(k1,k2) = 0;
        end
    end
end
figure;imshowpair(Input,Out_Image,'montage');

%% Filtering Using 2D Frequency Multiplication
clear; clc; close all
Input_Image_RGB = double(imread('Retina.png'));
Input = (Input_Image_RGB(:,:,1));
subplot(2,1,1); imshow(Input,[]); title('Input Image');
[h_im,w_im] = size(Input);
f = [-1,-1,-1;-1,9,-1;-1,-1,-1];
[h_f,w_f] = size(f);

% zero padding
n = log2(max([h_im w_im h_f w_f]));
N = 2^(fix(n) + 1); % padding to N
Input_Image_pad = zeros(N, N);
filter_pad = zeros(N, N);
Input_Image_pad(1 : h_im, 1 : w_im) = Input(:,:);
filter_pad(1 : h_f, 1 : w_f) = f(:,:);
FFT_img = fft2(Input_Image_pad);
FFT_filt = (fft2(filter_pad));

% find the inverse
r = real(ifft2(FFT_filt .* FFT_img));

%you may crop the output knowing half width of the filter.
f_w2 = floor(length(f)/2);
filt_img = r(1 + f_w2 : h_im + f_w2, 1 + f_w2 : w_im + f_w2);

%clipping > 255 and < 0, if sharpening
[h,w] = size(filt_img);
for k1=1:h
    for k2=1:w
        if (filt_img(k1,k2)>255)
            filt_img(k1,k2) = 255;
        end
        if (filt_img(k1,k2)<0)
            filt_img(k1,k2) = 0;
        end
    end
end
subplot(2,1,2); imshow(filt_img,[]); title('Input Image');



%% Homework 4 - Question 2
%
clear; clc; close all; 

% Parameters
A = 120;     % Amplitude
fx = 15; fy = 15; fs = 256;    % Sampling frequency in cycles/mm

% Create a spatial grid
x = linspace(0, 1, fs); y = linspace(0, 1, fs); 
[X, Y] = meshgrid(x, y);  % Create a meshgrid

% Define the 2D sinusoidal signals
F1 = 40 + A * sin(2 * pi * fx * X);
F2 = 40 + A * sin(2 * pi * fy * Y); 
F3 = 40 + A * sin(2 * pi * fx * X + 2 * pi * fy * Y);  % Combined signal

% Compute the 2D DFT (FFT) and shift it to center
DFT1 = fft2(F1); DFT1 = fftshift(DFT1); 
DFT2 = fft2(F2); DFT2 = fftshift(DFT2); 
DFT3 = fft2(F3); DFT3 = fftshift(DFT3); 

% Compute magnitude
mag1 = abs(DFT1); mag2 = abs(DFT2); mag3 = abs(DFT3); 

% Create u, v frequencies based on the FFT
u = linspace(-fs/2, fs/2-1, fs); 
v = linspace(-fs/2, fs/2-1, fs);
[u, v] = meshgrid(u, v);

% Plot Signal 1, Signal 2, and Signal 3
figure; hold on;
subplot(2,3,1); imagesc(F1); title('F1'); axis equal; axis off;
subplot(2,3,2); imagesc(F2); title('F2'); axis equal; axis off;
subplot(2,3,3); imagesc(F3); title('F3'); axis equal; axis off;

% 3D DFT Plots
cb = colorbar('south'); set(cb,'position',[.3 .025 .4 .025]);

subplot(2,3,4); surf(u, v, mag1, 'EdgeColor', 'none');  axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F1'); view(30, 30); 

subplot(2,3,5); surf(u, v, mag2, 'EdgeColor', 'none'); axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F2'); view(30, 30);

subplot(2,3,6); surf(u, v, mag3, 'EdgeColor', 'none');  axis square;
xlabel('Frequency (u)'); ylabel('Frequency (v)'); zlabel('Magnitude');
title('Magnitude of DFT of Signal F3'); view(30, 30);

for i=1:3
    colormap(subplot(2,3,i),"gray");
    colormap(subplot(2,3,i+3),"parula");
end
colormap(cb,"parula");

                        %% Lecture 14 - Frequency Domain Filtering

%% Homework 4 - Question 3
clear; clc; close all;

Input = imread('HDCT_Image.jpg'); % Load image
Input = im2double(rgb2gray(Input)); % Convert to grayscale
fs = 150; pixelsperinch = 250;
noiseperpixel = fs / pixelsperinch; % Noise frequency
[w, h] = size(Input); % image size
[u, v] = meshgrid(1:h, 1:w); % Create meshgrid
noise = sin(2 * pi * noiseperpixel * v); % periodic noise
noiseonimage = Input + noise; % Add noise

% Fourier transform
F = fft2(noiseonimage); F = fftshift(F); % Shift to zero

% Filter Parameters
Do1 = 100; Do2 = 145; Do3 = 150;
W = 20; size = 500; area = 400; % Yellow area size
xcent = 200; ycent = 200; % Circle center 

% Create meshgrid
[xgrid, ygrid] = meshgrid(1:size, 1:size);
[u, v] = meshgrid(-h/2:h/2-1, -w/2:w/2-1); % Frequency grid

figure;
%filter graph loop
for i = 1:3
    if i == 1
        Do = Do1;
    elseif i == 2
        Do = Do2;
    else
        Do = Do3;
    end
    
    % Calculate pixel distance
    pixel = Do / pixelsperinch; radius = Do; % Radius

    % Create yellow background for visualization
    filter = ones(size, size, 3); filter(:,:,3) = 0; 
    distancetocent = sqrt((xgrid - xcent).^2 + (ygrid - ycent).^2); % Calculate distance from center
    cout = distancetocent <= (radius + W / 2); % Outer circle boundary
    cin = distancetocent >= (radius - W / 2); % Inner circle boundary
    circle_mask = cout & cin; % Create circle mask
    filter(:,:,1) = filter(:,:,1) .* ~circle_mask; filter(:,:,2) = filter(:,:,2) .* ~circle_mask; 
    subplot(3, 2, 2*i - 1); imagesc(filter); axis image; set(gca, 'YDir', 'normal'); % Display circle
    title(['Filter = ', num2str(Do), ' cycles/inch, W = ', num2str(W)]);
    
    % Draw arrow and plot Do
    hold on; quiver(xcent - 10, ycent, radius, 0, 0, 'k', 'LineWidth', 1.5, 'MaxHeadSize', 1); % Draw radius arrow
    text(xcent, ycent, 'Do', 'HorizontalAlignment', 'center', 'FontSize', 12); % Label D0

    % Draw W arrows for bandwidth
    x_out = xcent + (radius + W / 2 + 5) * cos(pi / 2); y_out = ycent + (radius + W / 2 + 5) * sin(pi / 2); 
    x_in = xcent + (radius - W / 2 - 5) * cos(pi / 2); y_in = ycent + (radius - W / 2 - 5) * sin(pi / 2);
    plot(x_out, y_out, 'vk', 'MarkerFaceColor', 'k', 'MarkerSize', 5); % Upward arrow
    plot(x_in, y_in, '^k', 'MarkerFaceColor', 'k', 'MarkerSize', 5); % Downward arrow
    text(225, 365, 'W', 'HorizontalAlignment', 'center', 'FontSize', 12); % Label W above the top arrow
    hold off; xlim([0, size]); ylim([0, size]);
end

D = sqrt(u.^2 + v.^2); % Distance to center
H1 = exp(-0.5^2 * ((D.^2 - Do1^2) ./ (W * D)).^2); 
H2 = exp(-0.5^2 * ((D.^2 - Do2^2) ./ (W * D)).^2); 
H3 = exp(-0.5^2 * ((D.^2 - Do3^2) ./ (W * D)).^2);

% Apply the bandpass filter
G1 = H1 .* F; G2 = H2 .* F; G3 = H3 .* F;

% Inverse FFT (get filtered images)
G_ifft1 = ifftshift(G1); G_ifft2 = ifftshift(G2); G_ifft3 = ifftshift(G3); 
filtered_img1 = real(ifft2(G_ifft1)); filtered_img2 = real(ifft2(G_ifft2)); filtered_img3 = real(ifft2(G_ifft3));

% Output filtered images
subplot(3, 2, 2); imshow(filtered_img1, []); title('Filtered Output (Do = 100)');
subplot(3, 2, 4); imshow(filtered_img2, []); title('Filtered Output (Do = 145)');
subplot(3, 2, 6); imshow(filtered_img3, []); title('Filtered Output (Do = 150)');

                        %% Lecture 15 - Discrete Cosine Transform

%% DCT-based JPEG Compression

clear; clc; close all
Input_Data = [52 55 61 66 70 61 64 73;
        63 59 66 90 109 85 69 72;
        62 59 68 113 144 104 66 73;
        63 58 71 122 154 106 70 69;
        67 61 68 104 126 88 68 70;
        79 65 60 70 77 68 58 75;
        85 71 64 59 55 61 65 83;
        87 79 69 68 65 76 78 94];
Input_Data = Input_Data-128;
DCT_Output_Data = dct2(Input_Data);
DFT_Output_Data = abs(fft2(Input_Data));
subplot(1, 1, 1); imshow(DFT_Output_Data, []); title('Filtered Output (Do = 100)');

                        %% Lecture 16 - Discrete Wavelet Transform

%% Finding Wavelet Image Decomposition Using Daubechies of - Length 1-6

clear; clc; close all
Input_CT_RGB_Im = double(imread('Retina.png'));
X = Input_CT_RGB_Im(:,:,1);
[LO_D,HI_D,LO_R,HI_R] = wfilters('db1');
[c,s] = wavedec2(X,6,LO_D,HI_D); % Decomposing up to level 6

% Level 1 Coefficients
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s, 'db1',1);

% Level 2 Coefficients
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s, 'db1',2);

% Level 3 Coefficients
[H3,V3,D3] = detcoef2('all',c,s,3);
A3 = appcoef2(c,s,'db1',3);

% Level 4 Coefficients
[H4,V4,D4] = detcoef2('all',c,s,4);
A4 = appcoef2(c,s, 'db1',4);

% Level 5 Coefficients
[H5,V5,D5] = detcoef2('all',c,s,5);
A5 = appcoef2(c,s, 'db1',5);

% Level 6 Coefficients
[H6,V6,D6] = detcoef2('all',c,s,6);
A6 = appcoef2(c,s, 'db1',6);

% Level 1
figure;
subplot(2,2,1);
imshow(A1,[]); title('Approximation Coef. of Level 1');
subplot(2,2,2);
imshow(H1,[]); title('Horizontal detail Coef. of Level 1');
subplot(2,2,3);
imshow(V1,[]); title('Vertical detail Coef. of Level 1');
subplot(2,2,4);
imshow(D1,[]); title('Diagonal detail Coef. of Level 1');

% Level 2
figure;
subplot(2,2,1);
imshow(A2,[]); title('Approximation Coef. of Level 2');
subplot(2,2,2);
imshow(H2,[]); title('Horizontal detail Coef. of Level 2');
subplot(2,2,3);
imshow(V2,[]); title('Vertical detail Coef. of Level 2');
subplot(2,2,4);
imshow(D2,[]); title('Diagonal detail Coef. of Level 2');

% Level 3
figure;
subplot(2,2,1);
imshow(A3,[]); title('Approximation Coef. of Level 3');
subplot(2,2,2);
imshow(H3,[]); title('Horizontal detail Coef. of Level 3');
subplot(2,2,3);
imshow(V3,[]); title('Vertical detail Coef. of Level 3');
subplot(2,2,4);
imshow(D3,[]); title('Diagonal detail Coef. of Level 3');

% Level 4
figure;
subplot(2,2,1);
imshow(A4,[]); title('Approximation Coef. of Level 4');
subplot(2,2,2);
imshow(H4,[]); title('Horizontal detail Coef. of Level 4');
subplot(2,2,3);
imshow(V4,[]); title('Vertical detail Coef. of Level 4');
subplot(2,2,4);
imshow(D4,[]); title('Diagonal detail Coef. of Level 4');

% Level 5
figure;
subplot(2,2,1);
imshow(A5,[]); title('Approximation Coef. of Level 5');
subplot(2,2,2);
imshow(H5,[]); title('Horizontal detail Coef. of Level 5');
subplot(2,2,3);
imshow(V5,[]); title('Vertical detail Coef. of Level 5');
subplot(2,2,4);
imshow(D5,[]); title('Diagonal detail Coef. of Level 5');

% Level 6
figure;
subplot(2,2,1);
imshow(A6,[]); title('Approximation Coef. of Level 6');
subplot(2,2,2);
imshow(H6,[]); title('Horizontal detail Coef. of Level 6');
subplot(2,2,3);
imshow(V6,[]); title('Vertical detail Coef. of Level 6');
subplot(2,2,4);
imshow(D6,[]); title('Diagonal detail Coef. of Level 6');

%% Alternative Method to Finding Wavelet Input Decomposition - Levels 1,2,3 (Pink Output)

clear; clc; close all
Input_CT_RGB_Im = double(imread('Retina.png'));
X = Input_CT_RGB_Im(:,:,1);
[LO_D,HI_D,LO_R,HI_R] = wfilters('haar');
[c,s]=wavedec2(X,3,LO_D,HI_D);
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s,'haar',1);
V1img = wcodemat(V1,255,'mat',1); % Extended pseudocolor matrix scaling
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);

[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s,'haar',2);
V2img = wcodemat(V2,255,'mat',1);
H2img = wcodemat(H2,255,'mat',1);
D2img = wcodemat(D2,255,'mat',1);
A2img = wcodemat(A2,255,'mat',1);
[H3,V3,D3] = detcoef2('all',c,s,3);
A3 = appcoef2(c,s,'haar',3);
V3img = wcodemat(V3,255,'mat',1);
H3img = wcodemat(H3,255,'mat',1);
D3img = wcodemat(D3,255,'mat',1);
A3img = wcodemat(A3,255,'mat',1);

subplot(2,2,1);
imagesc(A1img); colormap pink(255); title('Approximation Coef. of Level 1');
subplot(2,2,2); imagesc(H1img); title('Horizontal detail Coef. of Level 1');
subplot(2,2,3); imagesc(V1img); title('Vertical detail Coef. of Level 1');
subplot(2,2,4); imagesc(D1img); title('Diagonal detail Coef. of Level 1');
subplot(2,2,1);
imagesc(A2img); colormap pink(255); title('Approximation Coef. of Level 2');
subplot(2,2,2); imagesc(H2img); title('Horizontal detail Coef. of Level 2');
subplot(2,2,3); imagesc(V2img); title('Vertical detail Coef. of Level 2');
subplot(2,2,4); imagesc(D2img); title('Diagonal detail Coef. of Level 2');
subplot(2,2,1);
imagesc(A3img); colormap pink(255); title('Approximation Coef. of Level 3');
subplot(2,2,2); imagesc(H3img); title('Horizontal detail Coef. of Level 3');
subplot(2,2,3); imagesc(V3img); title('Vertical detail Coef. of Level 3');
subplot(2,2,4); imagesc(D3img); title('Diagonal detail Coef. of Level 3'); 

%% Using Wavedec & Waverec to demonstrate Reconstruction

clear all; clc; close all
Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
X = Input_CT_RGB_Im(:,:,1);
[c,s]=wavedec2(X,3,'db1');
Rec_X = waverec2(c,s,'db1');
Def_Im = Rec_X - X;
Error = sum(sum(Def_Im));
figure;imshowpair(X,Rec_X,'montage');
figure;imshow(Def_Im,[0 255]);

%% Reconstructing Image Using Various Filtered Coefficients
% LPF, BPF, BSF, Horizontal Coefficients, Vertical Coefficients, Diagonal
% Coefficients, Horizontal and Vertical Coefficients, All Directional Coeff

clear; clc; close all;
Input_CT_RGB_Im = double(imread('Retina.png'));
X = Input_CT_RGB_Im(:,:,1);
% Perform wavelet decomposition (3 levels with db1 wavelet)
[c, s] = wavedec2(X, 3, 'db1');

% Level 1 Coefficients
[H1, V1, D1] = detcoef2('all', c, s, 1);
A1 = appcoef2(c, s, 'db1', 1);
[h1, w1, z] = size(A1);
A1_v = reshape(A1, h1 * w1, z);
H1_v = reshape(H1, h1 * w1, z);
V1_v = reshape(V1, h1 * w1, z);
D1_v = reshape(D1, h1 * w1, z);

% Level 2 Coefficients
[H2, V2, D2] = detcoef2('all', c, s, 2);
A2 = appcoef2(c, s, 'db1', 2);
[h2, w2, z] = size(A2);
A2_v = reshape(A2, h2 * w2, z);
H2_v = reshape(H2, h2 * w2, z);
V2_v = reshape(V2, h2 * w2, z);
D2_v = reshape(D2, h2 * w2, z);

% Level 3 Coefficients
[H3, V3, D3] = detcoef2('all', c, s, 3);
A3 = appcoef2(c, s, 'db1', 3);
[h3, w3, z] = size(A3);
A3_v = reshape(A3, h3 * w3, z);
H3_v = reshape(H3, h3 * w3, z);
V3_v = reshape(V3, h3 * w3, z);
D3_v = reshape(D3, h3 * w3, z);

%Create Different Filtered Coefficients
% LPF: Low-pass filter (Approximation Coefficients of Level 3)
C_LPF = [A3_v' 0 .* H3_v' 0 .* V3_v' 0 .* D3_v' 0 .* H2_v' 0 .* V2_v' 0 .* D2_v' 0 .* H1_v' 0 .* V1_v' 0 .* D1_v'];
Rec_X_LPF = waverec2(C_LPF, s, 'db1');

% BPF: Band-pass filter (Horizontal, Vertical, Diagonal coefficients of Level 3)
C_BPF = [0 .* A3_v' 1 .* H3_v' 1 .* V3_v' 1 .* D3_v' 0 .* H2_v' 0 .* V2_v' 0 .* D2_v' 0 .* H1_v' 0 .* V1_v' 0 .* D1_v'];
Rec_X_BPF = waverec2(C_BPF, s, 'db1');

% BSF: Band-stop filter (Only Approximation Coefficients)
C_BSF = [A3_v' 0 .* H3_v' 0 .* V3_v' 0 .* D3_v' 0 .* H2_v' 0 .* V2_v' 0 .* D2_v' 0 .* H1_v' 0 .* V1_v' 0 .* D1_v'];
Rec_X_BSF = waverec2(C_BSF, s, 'db1');

% Horizontal Coefficients (Only Horizontal)
C_Horizontal = [0 .* A3_v' 1 .* H3_v' 0 .* V3_v' 0 .* D3_v' 1 .* H2_v' 0 .* V2_v' 0 .* D2_v' 1 .* H1_v' 0 .* V1_v' 0 .* D1_v'];
Rec_X_Horizontal = waverec2(C_Horizontal, s, 'db1');

% Vertical Coefficients (Only Vertical)
C_Vertical = [0 .* A3_v' 0 .* H3_v' 1 .* V3_v' 0 .* D3_v' 0 .* H2_v' 1 .* V2_v' 0 .* D2_v' 0 .* H1_v' 1 .* V1_v' 0 .* D1_v'];
Rec_X_Vertical = waverec2(C_Vertical, s, 'db1');

% Horizontal and Vertical Coefficients
C_Horizontal_Vertical = [0 .* A3_v' 1 .* H3_v' 1 .* V3_v' 0 .* D3_v' 1 .* H2_v' 1 .* V2_v' 0 .* D2_v' 1 .* H1_v' 1 .* V1_v' 0 .* D1_v'];
Rec_X_Horizontal_Vertical = waverec2(C_Horizontal_Vertical, s, 'db1');

% Diagonal Coefficients (Only Diagonal)
C_Diagonal = [0 .* A3_v' 0 .* H3_v' 0 .* V3_v' 1 .* D3_v' 0 .* H2_v' 0 .* V2_v' 1 .* D2_v' 0 .* H1_v' 0 .* V1_v' 1 .* D1_v'];
Rec_X_Diagonal = waverec2(C_Diagonal, s, 'db1');

% Horizontal, Vertical, and Diagonal Coefficients Combined
C_HVD = [0 .* A3_v' 1 .* H3_v' 1 .* V3_v' 1 .* D3_v' 1 .* H2_v' 1 .* V2_v' 1 .* D2_v' 1 .* H1_v' 1 .* V1_v' 1 .* D1_v'];
Rec_X_HVD = waverec2(C_HVD, s, 'db1');

% Visualizing the Results
% Original vs LPF (Low-Pass Filtered)
figure; imshowpair(X, Rec_X_LPF, 'montage');
title('Original Image vs Low-Pass Filtered Image');

% Original vs BPF (Band-Pass Filtered)
figure; imshowpair(X, Rec_X_BPF, 'montage');
title('Original Image vs Band-Pass Filtered Image');

% Original vs BSF (Band-Stop Filtered)
figure; imshowpair(X, Rec_X_BSF, 'montage');
title('Original Image vs Band-Stop Filtered Image');

% Original vs Horizontal Coefficients
figure; imshowpair(X, Rec_X_Horizontal, 'montage');
title('Original Image vs Horizontal Coefficients');

% Original vs Vertical Coefficients
figure; imshowpair(X, Rec_X_Vertical, 'montage');
title('Original Image vs Vertical Coefficients');

% Original vs Horizontal and Vertical Coefficients
figure; imshowpair(X, Rec_X_Horizontal_Vertical, 'montage');
title('Original Image vs Horizontal & Vertical Coefficients');

% Original vs Diagonal Coefficients
figure; imshowpair(X, Rec_X_Diagonal, 'montage');
title('Original Image vs Diagonal Coefficients');

% Original vs Horizontal, Vertical, and Diagonal Combined Coefficients
figure; imshowpair(X, Rec_X_HVD, 'montage');
title('Original Image vs Horizontal, Vertical & Diagonal Coefficients');

