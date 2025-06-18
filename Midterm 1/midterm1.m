% James Pierce 
% jmp7247
% Midterm 1
% CMPEN 455
% 10/17/2024
clear; clc; close all

% Step 1 - Image Reading
Input_Im_RGB = imread('cat.png');
Input = Input_Im_RGB(:,:,1);
[H, W, C] = size(Input);


%figure; imshowpair(Input_Im_RGB,Input,'montage'); title('Loaded Image into Grayscale');

% Step 2 - Image Sharpening
W1 = [0 -1 0;-1 5 -1;0 -1 0]; % Sharpening filter
SharpIm = fix(convn(Input, W1, 'same'));

for k1=1:1:H
    for k2 =1:1:W
        if SharpIm(k1,k2)>255
            SharpIm(k1,k2) = 255;
        end
        if SharpIm(k1,k2)<0
            SharpIm(k1,k2) = 0;
        end
    end
end

SharpIm = uint8(SharpIm);
%figure; imshow(SharpIm/255); title('SharpIm');

% Step 3 and 4 - K-Means

K = 3; % Set the number of clusters
RGB_Data = double(reshape(SharpIm,H*W,C));

[labels,cluster_center] = kmeans(RGB_Data,K,'distance','sqEuclidean');
ClustIm = zeros(H*W,C);

% Fill outputs
for j = 1 : K
    k_idx = find(labels == j);
    for c = 1 : C
        ClustIm(k_idx, c) = cluster_center(j,c);
    end
end

ClustIm = reshape(ClustIm,[H,W,C]);
ClustIm = uint8(ClustIm);
%figure; imshow(ClustIm/255); title('ClustIm');


% Step 5 - 7x7 Box Filter

Box_Filter = (1/49).*ones(7,7);
BoxIm = uint8(fix(convn(ClustIm, Box_Filter, 'same')));

BoxIm = uint8(BoxIm);
%figure; imshow(BoxIm); title('BoxIm');

% Step 6 - Minimum Filter

MinIm = zeros(H,W);
W_Size = 7;

for i=fix(W_Size./2)+1:1:H-fix(W_Size./2)-1
    for j=fix(W_Size./2)+1:1:W-fix(W_Size./2)-1
        M = ClustIm(i-fix(W_Size./2):i+fix(W_Size./2),j-fix(W_Size./2):j+fix(W_Size./2));
        Min = min(M(:));
        MinIm(i,j) = Min;
    end
end

MinIm = uint8(MinIm);
%figure; imshow(MinIm); title("MinIm");

% Step 7 - Display Results


figure;
subplot(3,2,1); imshow(Input); title('Input');
subplot(3,2,2); imshow(SharpIm); title('SharpIm');
subplot(3,2,3); imshow(ClustIm); title('ClustIm');
subplot(3,2,4); imshow(BoxIm); title('BoxIm');
subplot(3,2,5); imshow(MinIm); title('MinIm');