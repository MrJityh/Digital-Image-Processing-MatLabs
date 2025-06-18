clc
clear
close all

R = 63;
G = 63;
B = 61;
mini = min([R G B]);

Brightness = 1/3 * (R + B + G)
Colorfulness = 1 - (3/(R+G+B))*mini