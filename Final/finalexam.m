clear; clc; close all
 
Input_Im_RGB = double(imread('flower.jpg'));
Grayscale = Input_Im_RGB(:,:,1);


% ## Part 1 - DFT
ImDFT = (abs((fftshift(Grayscale))));
figure; imshowpair(Grayscale, ImDFT,'montage'); title("DFT Something");

% ## Part 2 - 25x25 Box
W_1 = (1/(25*25)).*ones(25,25);

Output_Box_Im = uint8(fix(convn(Input_Im_RGB, W_1, 'same'))); % Box Filter
figure; imshowpair(uint8(Input_Im_RGB), Output_Box_Im,'montage'); title("Part 2 - 25x25 Box Filter");

% ## Part 3 - Color Space And K-Means
HSV_Im = rgb2hsv(Input_Im_RGB);
ValueChannel = HSV_Im(:,:,1);
%figure; imshow(ValueChannel); title('ValueChannel');
[H, W, C] = size(ValueChannel);
K = 3; % Set the number of clusters
Value_Data = double(reshape(ValueChannel,H*W,C));

ncluster = 3;
[cluster_idx,cluster_center] = kmeans(Value_Data,ncluster,'distance','sqEuclidean','Replicates',10);
Labeled_Image = reshape(cluster_idx,H,W);

figure; imshow(Labeled_Image,[]); title("Part 3 - Kmeans");

% ## Part 4 - Morphological
[H,W] = size(Grayscale);
Binarized_Im = Grayscale;

for i=1:H
    for j=1:W
        if Grayscale(i,j)>127
            Binarized_Im(i,j) = 1;
        end
        if Grayscale(i,j)<128
            Binarized_Im(i,j) = 0;
        end
    end
end

Mask = ones(25,25);

Eroded_Im = imerode(Binarized_Im, Mask);
Dilated_Im = imdilate(Binarized_Im, Mask);
 figure; subplot(1,3,1); imshow(Binarized_Im,[]); title('Binarized');
 subplot(1,3,2); imshow(Eroded_Im,[]); title('Eroded');
 subplot(1,3,3); imshow(Dilated_Im,[]); title('Dilated');

