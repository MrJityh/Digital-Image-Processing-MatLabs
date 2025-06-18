%% Wavelet decompositions and reconstructions
clear; clc; close all

Input_CT_RGB_Im = double(imread('noise_lung.png'));
X = Input_CT_RGB_Im(:,:,1);
subplot(3,2,1); imshow(X,[]); title('InputImage');
Levels = 2;

% 4 filters, orthogonal or biorthogonal wavelet
[LO_D,HI_D,LO_R,HI_R] = wfilters('db1'); %Daubechies
% LO/HI - Low-pass / High-Pass filter
% D/R - Decomposition / Reconstruction filter

% Returns wavelet decomp of X at level 'Levels'
[c,s] = wavedec2(X,Levels,LO_D,HI_D);

% Horizontal/Vertical/Diagnoal detail compoennts at level n
[H1,V1,D1] = detcoef2('all',c,s,1);
% Approximation level n
A1 = appcoef2(c,s, 'db1',1);
[h1,w1,z]= size(A1);
A1_v = reshape(A1,h1*w1,z);
H1_v = reshape(H1,h1*w1,z);
V1_v = reshape(V1,h1*w1,z);
D1_v = reshape(D1,h1*w1,z);
% Repeat for n=2
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s, 'db1',2);
[h2,w2,z]= size(A2);
A2_v = reshape(A2,h2*w2,z);
H2_v = reshape(H2,h2*w2,z);
V2_v = reshape(V2,h2*w2,z);
D2_v = reshape(D2,h2*w2,z);


% reconstructs using DWT structure [C,S]
Rec_X = waverec2(c,s,'db1');
subplot(3,2,2); imshow(Rec_X,[]); title('Wavelet Reconstructed')

C = [A2_v' 0.*H2_v' 0.*V2_v' 0.*D2_v' 0.*H1_v' 0.*V1_v' 0.*D1_v'];
% reconstructs using new 
Rec_X2 = waverec2(C,s,'db1');
subplot(3,2,3); imshow(Rec_X2,[]); title('Approximation Only (Denoised)');

C = [0.*A2_v' H2_v' 0.*V2_v' 0.*D2_v' H1_v' 0.*V1_v' 0.*D1_v'];
% reconstructs using new 
Rec_X2 = waverec2(C,s,'db1');
subplot(3,2,4); imshow(Rec_X2,[]); title('Horizontal Only');

C = [0.*A2_v' 0.*H2_v' V2_v' 0.*D2_v' 0.*H1_v' V1_v' 0.*D1_v'];
% reconstructs using new 
Rec_X2 = waverec2(C,s,'db1');
subplot(3,2,5); imshow(Rec_X2,[]); title('Vertical Only');

C = [0.*A2_v' H2_v' V2_v' 0.*D2_v' H1_v' V1_v' 0.*D1_v'];
% reconstructs using new 
Rec_X2 = waverec2(C,s,'db1');
subplot(3,2,6);imshow(Rec_X2,[]); title('Horizontal and Vertical');