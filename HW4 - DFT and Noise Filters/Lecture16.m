clear all; clc; close all
Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
X = Input_CT_RGB_Im(:,:,1);
[LO_D,HI_D,LO_R,HI_R] = wfilters(‘db1')
[c,s]=wavedec2(X,3,LO_D,HI_D);
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s, 'db1',1);
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s, 'db1',2);
[H3,V3,D3] = detcoef2('all',c,s,3);
A3 = appcoef2(c,s,’db1',3);
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

%%

clear all; clc; close all
Input_CT_RGB_Im = double(imread('HDCT_Image.jpg','jpg'));
X = Input_CT_RGB_Im(:,:,1);
[LO_D,HI_D,LO_R,HI_R] = wfilters('haar')
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