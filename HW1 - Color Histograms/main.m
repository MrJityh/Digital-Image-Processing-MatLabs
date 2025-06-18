clc
clear
close all
% Read the image
imageFile = 'colors.jpg'; % file name
rgbImage = imread(imageFile);

% Call the function to calculate and plot the histograms for each color plane
color_hist(rgbImage);