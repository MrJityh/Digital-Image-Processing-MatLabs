%% 3D DFT Method 1 with all visualizations

clc; clear; close all;

N = 201;
rect = zeros(N, N, N);
rect(98 : 102, 90 : 110, 80 : 120) = 50; % input
sinc = fftn(rect); % output
% for volume rect(x,y,z), apply FFT one dimension at a time

% Prep your 2D Slices
yx(:,:) = rect(:,:,100);
vu(:,:)=abs(fftshift(sinc(:,:,100)));
yz(:,:) = rect(:,100,:);
vw(:,:)=abs(fftshift(sinc(:,100,:)));
xz(:,:) = rect(100,:,:);
uw(:,:)=abs(fftshift(sinc(100,:,:)));

% 2D Images of Each Planar Slice at 100 
figure;
subplot(3,2,1); imshow(yx); title('yx spatial plane');

subplot(3,2,2); imshow(vu,[]); title('vu spatial plane');

subplot(3,2,3); imshow(yz); title('yz spatial plane');

subplot(3,2,4); imshow(vw,[]); title('vw spatial plane');

subplot(3,2,5); imshow(xz); title('xz spatial plane');

subplot(3,2,6); imshow(uw,[]); title('uw spatial plane');

% Another 2D visualization thing
figure;
mesh(xz); title('XZ Spatial Plane using Mesh, for Magnitudes'); axis equal;

% FFTShift for entire sinc, instead of individual (avoids complex??)
sinc = (abs((fftshift(sinc)))); 

% 3D Visualization through VolShow
volshow(rect);
volshow(sinc);

% 3D Visualization through Slice and Isoshape
figure; hold on; grid on; view(3); colormap(gray);
% Plot Slices at 100,100,100
slice(sinc, 100, 100, 100); shading interp; % Smooth the slice surfaces
% Labels
axis equal; xlabel('X'); ylabel('Y'); zlabel('Z'); 
title('Isosurface With Slices through 100,100,100');

%% 3D DFT Alternative method with simple visualization

clc; clear; close all;

N = 201;
rect = zeros(N, N, N);
rect(98 : 102, 90 : 110, 80 : 120) = 50; % input
sinc = zeros(201, 201, 201); % output
% for volume rect(x,y,z), apply FFT one dimension at a time
% apply 1-D FFT to z
for x = 1 : N
    for y = 1 : N
        h = rect(x, y, :);
        sinc(x, y, :) = fft(h) / N;
    end
end
% apply 1-D FFT to x
for z = 1 : N
    for y = 1 : N
        h = sinc(:, y, z);
        sinc(:, y, z) = fft(h) / N;
    end
end
% apply 1-D FFT to y
for z = 1 : N
    for x = 1 : N
        h = sinc(x, :, z);
        sinc(x, :, z) = fft(h) / N;
    end
end
sinc = (abs((fftshift(sinc))));

Max = max(sinc,[],"all");
Min = min(sinc,[],"all");
sinc = (sinc - Min)/(Max - Min);

sinc_yx = sinc(:,:,100);
% Through reshape
sinc_xz = reshape(sinc(100,:,:),[201,201]);
sinc_yz = reshape(sinc(:,100,:),[201,201]);
% Through Permute
sinc_xz_p = permute(sinc(100,:,:),[2 3 1]);
sinc_yz_p = permute(sinc(:,100,:),[1 3 2]);

%figure; imshow
figure; imshow(sinc_yx); title("YX");
figure; imshow(sinc_xz); title("XZ Reshaped");
figure; imshow(sinc_yz); title("YZ Reshaped");
figure; imshow(sinc_xz_p); title("XZ Permute");
figure; imshow(sinc_yz_p); title("YZ Permute");

%% Filtering using 2d Spatial Convolution or something

clear; clc; close all

Input_Image_RGB = double(imread('CT_Image_Filter.bmp','bmp'));
Input_Image = (Input_Image_RGB(:,:,1));

f = [-1,-1,-1;
     -1,9,-1;
     -1,-1,-1];

Out_Image = fix(conv2(Input_Image, f, 'same'));
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

figure;imshowpair(Input_Image,Out_Image,'montage')

%% 2D Frequency Multiplcation

clear; clc; close all

Input_Image_RGB = double(imread('CT_Image_Filter.bmp','bmp'));
Input_Image = (Input_Image_RGB(:,:,1));

[h_im,w_im] = size(Input_Image);
f = [-1,-1,-1;-1,9,-1;-1,-1,-1];
[h_f,w_f] = size(f);

% Zero Padding
n = log2(max([h_im w_im h_f w_f]));
N = 2^(fix(n) + 1); % padding to N

% Initialize
Input_Image_pad = zeros(N, N);
filter_pad = zeros(N, N);
% Assignment
Input_Image_pad(1 : h_im, 1 : w_im) = Input_Image(:,:);
filter_pad(1 : h_f, 1 : w_f) = f(:,:);
% Boom, they're padded 
FFT_img = fft2(Input_Image_pad);
FFT_filt = (fft2(filter_pad));

% Find the inverse
r = real(ifft2(FFT_filt .* FFT_img));
% You may crop the output knowing half width of the filter.
f_w2 = floor(length(f)/2);
filt_img = r(1 + f_w2 : h_im + f_w2, 1 + f_w2 : w_im + f_w2);

% Clipping > 255 and < 0, if sharpening
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

imshowpair(Input_Image_RGB,filt_img,'montage')

%% Lecture 13/HW 4

clc; clear; close all;

% Matlab Question 1
A = 120;
fx = 15; % cycles/unit
fy = 15; % cycles/unit
fs = 256; % cycles/unit
gridsize = 256;



