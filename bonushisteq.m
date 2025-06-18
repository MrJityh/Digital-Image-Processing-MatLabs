clc
clear
close all

image = imread('Lecture 6/CT_Image.jpg');

Input_Im = image(:,:,1);
G = 256;
Y = size(Input_Im,1);
X = size(Input_Im,2);

Output_Im = histeq(Input_Im);
imshowpair(Input_Im,Output_Im,'montage')
title('Using HistEQ');

figure; imhist(Input_Im); title('Input');
figure; imhist(Output_Im); title('Output of HistEQ');

%figure
value_freq = imhist(Input_Im);
%bar(value_freq); title('Freq');

%figure
pixels = Y*X;
value_prob = value_freq/pixels;
%bar(value_prob); title('Prob');


Cin = zeros(256,1);
for i = 1:1:255
    Cin(i, 1) = sum(value_prob(1:i));
end

%
figure
bar(Cin); title('Cumulative');
Cin = floor(Cin*G);

%Reform the image using the new cumulative function to find the equalized
%gray levels
Final_Im = uint8(zeros(Y,X));
for i=1:size(Input_Im,1)
    for j=1:size(Input_Im,2)
            Final_Im(i,j)=Cin(Input_Im(i,j)+1);
    end
end

%Plot Both Images
figure
imshowpair(Input_Im,Final_Im,'montage');
title('Using Custom EQ Function');