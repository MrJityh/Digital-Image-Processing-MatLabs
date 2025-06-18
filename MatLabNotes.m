%## MatLab Assistance
%
%   Functions:
%       - disp(variablename)
%           displays results without identifying variable names
%       - pause
%           pauses until the user presses any keyboard key
%       - pause (n)
%           pauses for n seconds 
%       - echo
%           writes the script file and contents as they are executed onto
%           command window
%       - pi
%           ratio of circumference to diameter 3.14...
%       - waitforbuttonpress
%           wait until mouse button
% 
%   Special Variables:
%       - ans - default variable for results
%       - beep - makes computer sound a beep
%       - eps - smallest number that when added to 1 creates a number
%               greater than 1
%       - inf - infinity
%       - nan - not a number (e.g. 0/0)
%       - i or j - square root of -1
%
%   Commands:
%       - who - list the variable names that exist in workspace
%       - whos - list variables and their values that exist
%
%## MatLab Matrices:
%   Functions:
%       - sum(A)
%           return the summation of each column of A (matrix)
%       - A' 
%           returns the transpose (flip over \ diagnol) of matrix A
%       - diag(A)
%           returns the main diagnol (\) of matrix A
%       - sum(diag(A))
%           returns the sum of diagnol of A
%       - A>30
%           returns ones for the values greater than 30 in the same size
%           matrix
%       - sort(A) [can do (sort(A,'descend') to flip]
%           sort the values of array A, lowest left highest right,
%           matrixes sort columns, lowest top highest bottom 
%       - tril
%           returns the diagnol \ and lower triagular part of matrix A
%       - size(A)
%           returns two values, the amount of rows and columns
%       - zeros(n,m)
%           return n rows by m columns matrix of zeros
%       - ones(n,m)
%           return n by m matrix of ones
%       - eye(n,m)
%           return n by m identity matrix (\ is 1s, all else is 0)
%       - rand(n,m)
%           return n by m matrix with random entries on interval (0,1)
%
%   Weird Things:
%       - A(:) = everything
%       - A(:,2) = everything inside 2nd column
%       - A(3,:) = everything inside 3rd row
%       - A(2,2:3) = 2nd row, 2nd through 3rd column
%       - A(2,2:end) = 2nd row, 2nd column onward
%
%   Operators:
%       +   Addition/summation scalar (A + 5) or matrix (A + B)
%       -   Subtraction scalar (A - 5) or matrix (A - B)
%       *   Matrix Muplication (A * 5)
%       .*  Multiply element by element (A .* B)
%       /   Matrix Division (A / 5) 
%       ./  Divide Element by Element (A ./ B)
%       ^   Power (A .^2 = squares each element of A) 
%
%%
clc
clear
close all

A = [0 1 1 0;
     0 2 2 3;
     0 1 1 3;
     0 2 3 3];
X = 0:3;
Y = [0 0 0 0];

%Number of grey levels = 4 [0,1,2,3]
for i = 0 : 3
    [r, c, f] = find(A == 1*i);
    Y(i+1) = sum(f);
end
Y;

%Example 1, flawed because x-values are 1-4 not 0-3
bar(Y);
%Example 2, bar plot again, but with fixed axes
figure
bar(X,Y); 
%Example 3, correct x-values but in a continuous plot... 
figure
plot(X,Y);

%% WIP GRAB FROM LECTURE
clc
clear all
close all
X = imread('CT.bmp','bmp');
Y = double(X);
figure
imshow(Y,[0,255])
[h, w] = size(y);
for i = 0:1:255
    [r, c, f] = find(Y == i);
    hist_image
end
%% ## Color Spaces
%       - RGB 
%       - CMY(K)
%       - HSI(or HSV) (Hue, Saturation, Intensity (or Value)) 
%       - YCbCy (Luminance (gray level), Chroma Blue, Chroma Red)
%
%
%
%
%
%






