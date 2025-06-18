clc
clear
close all

%Part 1
rgbImage = imread('DarkImage.bmp');
yccImage = rgb2ycbcr(rgbImage);
Y_ORG = yccImage(:,:,1);
sizeY = size(rgbImage,1);
sizeX = size(rgbImage,2);

%Part 2
figure;
imhist(Y_ORG); title('Original Histogram');

%Part 3
Y_EQ = histeq(Y_ORG);
figure;
imhist(Y_EQ); title('Equalized Histogram');

%Part 4
figure; 
imshowpair(Y_ORG,Y_EQ,'montage'); title('Comparing Y_ORG to Y_EQ');

figure; 
restoredImage(:,:,1) = Y_EQ;
restoredImage(:,:,2) = yccImage(:,:,2);
restoredImage(:,:,3) = yccImage(:,:,3);
imshowpair(rgbImage,restoredImage,'montage'); title('Comparing rgbImage to Restored Ycc');

%Part 5
Y_BIN_ORG = zeros(sizeY,sizeX);
Y_BIN_EQ = zeros(sizeY,sizeX);

for i = 1:1:sizeY
    for j = 1:1:sizeX
        if Y_ORG(i,j) > 128
            Y_BIN_ORG(i,j) = 1;
        elseif Y_ORG(i,j) < 128
            Y_BIN_ORG(i,j) = 0;
        end
    end
end

for i = 1:1:sizeY
    for j = 1:1:sizeX
        if Y_EQ(i,j) > 128
            Y_BIN_EQ(i,j) = 1;
        elseif Y_EQ(i,j) < 128
            Y_BIN_EQ(i,j) = 0;
        end
    end
end

%Part 6
binEQRestored(:,:,1)  = Y_BIN_EQ;
binEQRestored(:,:,2) = yccImage(:,:,2);
binEQRestored(:,:,3) = yccImage(:,:,3);
figure; 
imshowpair(rgbImage,binEQRestored,'montage'); title('Original vs Binary EQ Restored')

binRestored(:,:,1)  = Y_BIN_ORG;
binRestored(:,:,2) = yccImage(:,:,2);
binRestored(:,:,3) = yccImage(:,:,3);
figure; 
imshowpair(rgbImage,binRestored,'montage'); title('Original vs Binary Restored')