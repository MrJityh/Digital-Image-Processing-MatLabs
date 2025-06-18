%% Wavelet decompositions
clear; clc; close all

Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));

X = Input_CT_RGB_Im(:,:,1);

% 4 filters, orthogonal or biorthogonal wavelet
[LO_D,HI_D,LO_R,HI_R] = wfilters('db1'); %Daubechies
% LO/HI - Low-pass / High-Pass filter
% D/R - Decomposition / Reconstruction filter

% Returns wavelet decomp of X at level 3
[c,s]=wavedec2(X,3,LO_D,HI_D);

% Horizontal/Vertical/Diagnoal detail compoennts at level n
[H1,V1,D1] = detcoef2('all',c,s,1);
% Approximation level n
A1 = appcoef2(c,s, 'db1',1);

% Repeat for n=2 and 3
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s, 'db1',2);
[H3,V3,D3] = detcoef2('all',c,s,3);
A3 = appcoef2(c,s,'db1',3);

% Display
figure
subplot(2,2,1);
imshow(A1,[]);
title('Approximation Coef. of Level 1');
subplot(2,2,2);
imshow(H1,[]);
title('Horizontal detail Coef. of Level 1');
subplot(2,2,3);
imshow(V1,[]);
title('Vertical detail Coef. of Level 1');
subplot(2,2,4);
imshow(D1,[]);
title('Diagonal detail Coef. of Level 1');

figure
subplot(2,2,1);
imshow(A2,[]);
title('Approximation Coef. of Level 2');
subplot(2,2,2);
imshow(H2,[]);
title('Horizontal detail Coef. of Level 2');
subplot(2,2,3);
imshow(V2,[]);
title('Vertical detail Coef. of Level 2');
subplot(2,2,4);
imshow(D2,[]);
title('Diagonal detail Coef. of Level 2');

figure
subplot(2,2,1);
imshow(A3,[]);
title('Approximation Coef. of Level 3');
subplot(2,2,2);
imshow(H3,[]);
title('Horizontal detail Coef. of Level 3');
subplot(2,2,3);
imshow(V3,[]);
title('Vertical detail Coef. of Level 3');
subplot(2,2,4);
imshow(D3,[]);
title('Diagonal detail Coef. of Level 3');

%% Alternative way of displaying Wavelet results
clear; clc; close all

Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
X = Input_CT_RGB_Im(:,:,1);

[LO_D,HI_D,LO_R,HI_R] = wfilters('haar');
[c,s]=wavedec2(X,3,LO_D,HI_D);
[H1,V1,D1] = detcoef2('all',c,s,1);

A1 = appcoef2(c,s,'haar',1);

V1img = wcodemat(V1,255,'mat',1); % Extended pseudocolor matrix scaling
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);

[H2,V2,D2] = detcoef2('all',c,s,2);

A2 = appcoef2(c,s,'haar',2);

V2img = wcodemat(V2,255,'mat',1);
H2img = wcodemat(H2,255,'mat',1);
D2img = wcodemat(D2,255,'mat',1);
A2img = wcodemat(A2,255,'mat',1);

[H3,V3,D3] = detcoef2('all',c,s,3);

A3 = appcoef2(c,s,'haar',3);

V3img = wcodemat(V3,255,'mat',1);
H3img = wcodemat(H3,255,'mat',1);
D3img = wcodemat(D3,255,'mat',1);
A3img = wcodemat(A3,255,'mat',1);

subplot(2,2,1);
imagesc(A1img);
colormap pink(255);
title('Approximation Coef. of Level 1');
subplot(2,2,2);
imagesc(H1img);
title('Horizontal detail Coef. of Level 1');
subplot(2,2,3);
imagesc(V1img);
title('Vertical detail Coef. of Level 1');
subplot(2,2,4);
imagesc(D1img);
title('Diagonal detail Coef. of Level 1');
subplot(2,2,1);
imagesc(A2img);
colormap pink(255);
title('Approximation Coef. of Level 2');
subplot(2,2,2);
imagesc(H2img);
title('Horizontal detail Coef. of Level 2');
subplot(2,2,3);
imagesc(V2img);
title('Vertical detail Coef. of Level 2');
subplot(2,2,4);
imagesc(D2img);
title('Diagonal detail Coef. of Level 2');
subplot(2,2,1);
imagesc(A3img);
colormap pink(255);
title('Approximation Coef. of Level 3');
subplot(2,2,2);
imagesc(H3img);
title('Horizontal detail Coef. of Level 3');
subplot(2,2,3);
imagesc(V3img);
title('Vertical detail Coef. of Level 3');
subplot(2,2,4);
imagesc(D3img);
title('Diagonal detail Coef. of Level 3');


%% Reconstruction Accuracy of Wavelet Transformation

clear; clc; close all;

Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
 X = Input_CT_RGB_Im(:,:,1);
 [c,s]=wavedec2(X,3,'db1');
 Rec_X = waverec2(c,s,'db1');
 Def_Im = Rec_X - X;
 Error = sum(sum(Def_Im));
 figure;imshowpair(X,Rec_X,'montage') 
figure;imshow(Def_Im,[0 255])

%% Reconstructing from LPF coefficients

 clear; clc; close all;

 Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
 X = Input_CT_RGB_Im(:,:,1);
 [c,s]=wavedec2(X,3,'db1');
 
 [H1,V1,D1] = detcoef2('all',c,s,1);
 A1 = appcoef2(c,s,'haar',1); 
[h1,w1,z]= size(A1);
 A1_v = reshape(A1,h1*w1,z);
 H1_v= reshape(H1,h1*w1,z);
 V1_v= reshape(V1,h1*w1,z);
 D1_v= reshape(D1,h1*w1,z);

 [H2,V2,D2] = detcoef2('all',c,s,2);
 A2 = appcoef2(c,s,'haar',2); 
[h2,w2,z]= size(A2);
 A2_v = reshape(A2,h2*w2,z);
 H2_v= reshape(H2,h2*w2,z);
 V2_v= reshape(V2,h2*w2,z);
 D2_v= reshape(D2,h2*w2,z);
 
 [H3,V3,D3] = detcoef2('all',c,s,3);
 A3 = appcoef2(c,s,'haar',3); 
[h3,w3,z]= size(A3);
 A3_v = reshape(A3,h3*w3,z);
 H3_v= reshape(H3,h3*w3,z);
 V3_v= reshape(V3,h3*w3,z);
 D3_v= reshape(D3,h3*w3,z);

 C = [A3_v' 0.*H3_v' 0.*V3_v' 0.*D3_v' 0.*H2_v' 0.*V2_v' 0.*D2_v' 0.*H1_v' 0.*V1_v' 0.*D1_v'];
 Rec_X = waverec2(c,s,'db1');
 figure;imshowpair(X,Rec_X,'montage');
Rec_X2 = waverec2(C,s,'db1');
 figure;imshowpair(X,Rec_X2,'montage');