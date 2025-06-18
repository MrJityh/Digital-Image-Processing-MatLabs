%%
clc;
clear;
close all;
load('starFish_project.mat'); % Load the dataset
K = 5; % Set the number of clusters
if iscell(F) % Check if F is a cell array
for i = 1 : 6 % If F is a cell array, extract the first image or data element (assuming it's consistent)
inputImg = cell2mat(F(i)); % Grab image
[H, W, C] = size(inputImg);
RGB_Data = double(reshape(inputImg,H*W,C)); % Flatten the image into 2D matrix of RGB pixel data
[labels,cluster_center] = kmeans(RGB_Data,K,'distance','sqEuclidean','Replicates',1);
new_output = zeros(H*W,C); % Initialize variables
for j = 1 : K
k_idx = find(labels == j);
for c = 1 : C
new_output(k_idx, c) = cluster_center(j,c);
end
end
new_output = reshape(new_output,[H,W,C]); % Reshape and then display output
figure; imshowpair(inputImg,new_output/255,'montage');
end
end