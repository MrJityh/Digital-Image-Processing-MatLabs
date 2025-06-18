%% This document covers Smoothing, Spatial, and Sharpening Filters
% Smoothing an OCTA image

clear; clc; close all

Input_Im_RGB = double(imread('OCTA_02.jpg'));
Input_Im = Input_Im_RGB(:,:,1);

W_1 = (1/9).*ones(3,3);
W_2 = (1./16).*[1 2 1;2 4 2;1 2 1];

Output_Im_1 = fix(convn(Input_Im, W_1, 'same'));
Output_Im_2 = fix(convn(Input_Im, W_2, 'same'));

figure; imshowpair(Input_Im,Output_Im_1,'montage')
figure; imshowpair(Input_Im,Output_Im_2,'montage')

%% Smoothing an MRA volume (Slices)

clear; clc; close all
No_Images = 136;

for index = 1:1:No_Images
    Image_Name = sprintf('%s%.3d%s','Slice_',index,'.bmp'); % String = 'Slice_', %.3d = 3 digits from index, % string = '.bmp'
    Input_Image_RGB = double(imread(Image_Name ));
    MRA_Volume(:,:,index) = Input_Image_RGB(:,:,1); %#ok<SAGROW>
end

W_1 = (1/27).*ones(3,3,3);
W_2(:,:,1) = (1./64).*[1 2 1;2 4 2;1 2 1];
W_2(:,:,2) = (1./64).*[2 4 2;4 8 4;2 4 2];
W_2(:,:,3) = (1./64).*[1 2 1;2 4 2;1 2 1];

Output_Im_1 = fix(convn(MRA_Volume, W_1, 'same'));
Output_Im_2 = fix(convn(MRA_Volume, W_2, 'same'));

figure; imshowpair(MRA_Volume(:,:,2),Output_Im_1(:,:,2),'montage')
figure; imshowpair(MRA_Volume(:,:,2),Output_Im_2(:,:,2),'montage')

%% Box and Gaussian Smoothing

clear; clc; close all

Input_Im_RGB = (imread('Zebra.jpg'));
Input_Im_YCrCb = rgb2ycbcr(Input_Im_RGB);

Input_Im_Y = Input_Im_YCrCb(:,:,1);
Input_Im_Cr = Input_Im_YCrCb(:,:,2);
Input_Im_Cb = Input_Im_YCrCb(:,:,3);

W_1 = (1/9).*ones(3,3);
W_2 = (1./16).*[1 2 1;2 4 2;1 2 1];

Output_Im_Y1 = uint8(fix(convn(Input_Im_Y, W_1, 'same')));
Output_Im_Y2 = uint8(fix(convn(Input_Im_Y, W_2, 'same')));

Output_Im_1(:,:,1)= Output_Im_Y1;
Output_Im_1(:,:,2)= Input_Im_Cr;
Output_Im_1(:,:,3)= Input_Im_Cb;
Output_Im_2(:,:,1)= Output_Im_Y2;
Output_Im_2(:,:,2)= Input_Im_Cr;
Output_Im_2(:,:,3)= Input_Im_Cb;

Output_Im_RGB_1 = (ycbcr2rgb(Output_Im_1));
Output_Im_RGB_2 = (ycbcr2rgb(Output_Im_2));

figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_1,'montage'), title("3x3 Box Smoothing");
figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_2,'montage'), title("3x3 Gaussian Smoothing");

%% Box and Gaussian Smoothing of Different Sizes

clear; clc; close all

Input_Im_RGB = (imread('Template.png'));
Input_Im_YCrCb = rgb2ycbcr(Input_Im_RGB);
Input_Im_Y = Input_Im_YCrCb(:,:,1);
Input_Im_Cr = Input_Im_YCrCb(:,:,2);
Input_Im_Cb = Input_Im_YCrCb(:,:,3);

% "3x3 Box Smoothing"
W_1 = (1/9).*ones(3,3);
% "3x3 Gaussian Smoothing"
W_2 = (1./16).*[1 2 1;2 4 2;1 2 1];
% "5x5 Box Smoothing"
W_3 = (1/25).*ones(5,5);
% "5x5 Gaussian Smoothing"
W_4= (1./256).*[1 4 6 4 1;4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1];


Output_Im_Y1 = uint8(fix(convn(Input_Im_Y, W_1, 'same'))); % "3x3 Box Smoothing"
Output_Im_Y2 = uint8(fix(convn(Input_Im_Y, W_2, 'same'))); % "3x3 Gaussian Smoothing"
Output_Im_Y3 = uint8(fix(convn(Input_Im_Y, W_3, 'same'))); % "5x5 Box Smoothing"
Output_Im_Y4 = uint8(fix(convn(Input_Im_Y, W_4, 'same'))); % "5x5 Gaussian Smoothing"

Output_Im_1(:,:,1)= Output_Im_Y1;
Output_Im_1(:,:,2)= Input_Im_Cr;
Output_Im_1(:,:,3)= Input_Im_Cb;

Output_Im_2(:,:,1)= Output_Im_Y2;
Output_Im_2(:,:,2)= Input_Im_Cr;
Output_Im_2(:,:,3)= Input_Im_Cb;

Output_Im_3(:,:,1)= Output_Im_Y3;
Output_Im_3(:,:,2)= Input_Im_Cr;
Output_Im_3(:,:,3)= Input_Im_Cb;

Output_Im_4(:,:,1)= Output_Im_Y4;
Output_Im_4(:,:,2)= Input_Im_Cr;
Output_Im_4(:,:,3)= Input_Im_Cb;

Output_Im_RGB_1 = (ycbcr2rgb(Output_Im_1)); 
Output_Im_RGB_2 = (ycbcr2rgb(Output_Im_2));
Output_Im_RGB_3 = (ycbcr2rgb(Output_Im_3));
Output_Im_RGB_4 = (ycbcr2rgb(Output_Im_4));

figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_1,'montage'); title("3x3 Box Smoothing");
figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_2,'montage'); title("3x3 Gaussian Smoothing");
figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_3,'montage'); title("5x5 Box Smoothing");
figure; imshowpair(Input_Im_RGB ,Output_Im_RGB_4,'montage'); title("5x5 Gaussian Smoothing");

%% Filtering an Image using a Median Filter of Different Window Size

clear; clc; close all

Input_Im_RGB = double(imread('HDCT_Image.jpg'));
Input_Im(:,:) = Input_Im_RGB(:,:,1);

Output_Im_3_3 = medfilt2(Input_Im,[3 3]);
figure; imshowpair(Input_Im,Output_Im_3_3,'montage'); title("3x3 Median Filter");

Output_Im_5_5 = medfilt2(Input_Im,[5 5]);
figure; imshowpair(Input_Im,Output_Im_5_5,'montage'); title("5x5 Median Filter");

Output_Im_7_7 = medfilt2(Input_Im,[7 7]);
figure; imshowpair(Input_Im,Output_Im_7_7,'montage'); title("7x7 Median Filter");

Output_Im_9_9 = medfilt2(Input_Im,[9 9]);
figure; imshowpair(Input_Im,Output_Im_9_9,'montage'); title("9x9 Median Filter");

%% Filtering an Image using a Minimum and Maximum Filters with different window sizes

clear; clc; close all;

Input_Im_RGB = double(imread('HDCT_Image.jpg'));
Input_Im(:,:) = Input_Im_RGB(:,:,1);

[h,w] = size(Input_Im);
Im_Min = zeros(h,w);
Im_Max = zeros(h,w);
W_Size = 3;

for i=fix(W_Size./2)+1:1:h-fix(W_Size./2)-1
    for j=fix(W_Size./2)+1:1:w-fix(W_Size./2)-1
        M = Input_Im(i-fix(W_Size./2):i+fix(W_Size./2),j-fix(W_Size./2):j+fix(W_Size./2));
        Min = min(M(:));
        Max = max(M(:));
        Im_Min(i,j) = Min;
        Im_Max(i,j) = Max;
    end
end

figure; imshowpair(Input_Im,Im_Min,'montage'); title("Minimum Filter");
figure; imshowpair(Input_Im,Im_Max,'montage'); title("Maximum Filter");

%% Min/25%/Median/75%/Max Spatial Filters

clear; clc; close all
Input_Im_RGB = double(imread('Template.png'))./255; %Choose image and normalize?

I_ycc = rgb2ycbcr(Input_Im_RGB); % RGB to Ycbcr to filter the Luminance
y = I_ycc(:,:,1); % Luminance
Input_Im(:,:) = y; % Set input
[h,w] = size(Input_Im); % Get height and width of input image

% Initialize the size of each output layer to match the luminance layer
Im_Min = y;
Im_25 = y;
Im_Med = y;
Im_75 = y;
Im_Max = y;

% Width of the grid and # of cells in grid
W_Size = 3;
Cells = W_Size*W_Size;

for i=fix(W_Size./2)+1:1:h-fix(W_Size./2)-1
    for j=fix(W_Size./2)+1:1:w-fix(W_Size./2)-1
        % Get the 'overlay' grid around the current pixel
        M = Input_Im(i-fix(W_Size./2):i+fix(W_Size./2),j-fix(W_Size./2):j+fix(W_Size./2));
        % Get the sorted grid from smallest to largest in an array, for percentile filters
        sorted = sort(M(:));
        % Min, 25%, Median, 75%, Max
        Im_Min(i,j) = min(M(:));
        Im_25(i,j) = sorted(uint8(.25*Cells));
        Im_Med(i,j) = median(M(:));
        Im_75(i,j) = sorted(uint8(.75*Cells));
        Im_Max(i,j) = max(M(:));
    end
end

% Combine and display all 3x3 filter outputs
I_ycc(:,:,1) = Im_Min(:,:,1); % Use the filtered layer as the luminance layer
I = ycbcr2rgb(I_ycc); % Convert back to RGB for color
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Minimum Filter 3x3");
I_ycc(:,:,1) = Im_25(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("25% Filter 3x3");
I_ycc(:,:,1) = Im_Med(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Median Filter 3x3");
I_ycc(:,:,1) = Im_75(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("75% Filter 3x3");
I_ycc(:,:,1) = Im_Max(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Maximum Filter 3x3");

% ##BELOW IS JUST A REPEAT FOR 7x7 GRIDS

% Width of the grid and # of cells in grid
W_Size = 7;
Cells = W_Size*W_Size;

for i=fix(W_Size./2)+1:1:h-fix(W_Size./2)-1
    for j=fix(W_Size./2)+1:1:w-fix(W_Size./2)-1
        % Get the 'overlay' grid around the current pixel
        M = Input_Im(i-fix(W_Size./2):i+fix(W_Size./2),j-fix(W_Size./2):j+fix(W_Size./2));
        % Get the sorted grid from smallest to largest in an array, for percentile filters
        sorted = sort(M(:));
        % Min, 25%, Median, 75%, Max
        Im_Min(i,j) = min(M(:));
        Im_25(i,j) = sorted(uint8(.25*Cells));
        Im_Med(i,j) = median(M(:));
        Im_75(i,j) = sorted(uint8(.75*Cells));
        Im_Max(i,j) = max(M(:));
    end
end

% Combine and display all 7x7 filter outputs
I_ycc(:,:,1) = Im_Min(:,:,1); % Use the filtered layer as the luminance layer
I = ycbcr2rgb(I_ycc); % Convert back to RGB for color
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Minimum Filter 7x7");
I_ycc(:,:,1) = Im_25(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("25% Filter 7x7");
I_ycc(:,:,1) = Im_Med(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Median Filter 7x7");
I_ycc(:,:,1) = Im_75(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("75% Filter 7x7");
I_ycc(:,:,1) = Im_Max(:,:,1);
I = ycbcr2rgb(I_ycc);
figure; imshowpair(Input_Im_RGB,I,'montage'); title("Maximum Filter 7x7");

%% Sharpening Filters
clear; clc; close all
Input_Im_RGB = double(imread('HDCT_Image.jpg'));
Input_Im = Input_Im_RGB(:,:,1);
[h, w] = size(Input_Im);
W_L = [0 -1 0;-1 4 -1;0 -1 0]; %Laplacian, DC gain = 1 gets you edges
W_1 = [0 -1 0;-1 5 -1;0 -1 0]; %Correct cause dc gain = 2;
W_2 = [-1 -1 -1;-1 9 -1;-1 -1 -1]; %
Output_Im_L = fix(convn(Input_Im, W_L, 'same'));
Output_Im_1 = fix(convn(Input_Im, W_1, 'same'));
Output_Im_2 = fix(convn(Input_Im, W_2, 'same'));

for k1=1:1:h
    for k2 =1:1:w
        if Output_Im_L(k1,k2)>255
            Output_Im_L(k1,k2) = 255;
        end
        if Output_Im_L(k1,k2)<0
            Output_Im_L(k1,k2) = 0;
        end
        if Output_Im_1(k1,k2)>255
            Output_Im_1(k1,k2) = 255;
        end
        if Output_Im_1(k1,k2)<0
            Output_Im_1(k1,k2) = 0;
        end
        if Output_Im_2(k1,k2)>255
            Output_Im_2(k1,k2) = 255;
        end
        if Output_Im_2(k1,k2)<0
            Output_Im_2(k1,k2) = 0;
        end
    end
end

figure; imshowpair(Input_Im,Output_Im_L,'montage'); title('WL Laplacian Filter');
figure; imshowpair(Input_Im,Output_Im_1,'montage'); title('W1');
figure; imshowpair(Input_Im,Output_Im_2,'montage'); title('W2');

%% Sharpening a MRA 3d Volume
clear; clc; close all
No_Images = 136;

for index = 1:1:No_Images
    Image_Name = sprintf('%s%.3d%s','Slice_',index,'.bmp');
    Input_Image_RGB = double(imread(Image_Name ));
    MRA_Volume(:,:,index) = Input_Image_RGB(:,:,1);
end

W_1(:,:,1) = [-1 -1 -1;-1 -1 -1;-1 -1 -1];
W_1(:,:,2) = [-1 -1 -1;-1 27 -1;-1 -1 -1];
W_1(:,:,3) = [-1 -1 -1;-1 -1 -1;-1 -1 -1];
W_2(:,:,1) = [0 -1 0;-1 -1 -1;0 -1 0];
W_2(:,:,2) = [-1 -1 -1;-1 19 -1;-1 -1 -1];
W_2(:,:,3) = [0 -1 0;-1 -1 -1;0 -1 0];
Output_Im_1 = fix(convn(MRA_Volume, W_1, 'same'));
Output_Im_2 = fix(convn(MRA_Volume, W_2, 'same'));
[h,w,z] = size(Output_Im_1);

for k3=1:1:z
    for k1=1:1:h
        for k2=1:1:w
            if Output_Im_1(k1,k2,k3)>255
                Output_Im_1(k1,k2,k3) = 255;
            end
            if Output_Im_1(k1,k2,k3)<0
                Output_Im_1(k1,k2,k3) = 0;
            end
            if Output_Im_2(k1,k2,k3)>255
                Output_Im_2(k1,k2,k3) = 255;
            end
            if Output_Im_2(k1,k2,k3)<0
                Output_Im_2(k1,k2,k3) = 0;
            end
        end
    end
end

figure; imshowpair(MRA_Volume(:,:,2),Output_Im_1(:,:,2),'montage')
figure; imshowpair(MRA_Volume(:,:,2),Output_Im_2(:,:,2),'montage')