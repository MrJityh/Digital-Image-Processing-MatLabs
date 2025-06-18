clear all; clc; close all
 
Input_CT_RGB_Im = double(imread('noise_lung.png','png'));
X = Input_CT_RGB_Im(:,:,1);

[c,s]=wavedec2(X,2,'db1');
 
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s,'haar',1); 

[h1 w1 z]= size(A1);
A1_v = reshape(A1,h1*w1,z);
H1_v= reshape(H1,h1*w1,z);
V1_v= reshape(V1,h1*w1,z);
D1_v= reshape(D1,h1*w1,z);

[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s,'haar',2); 
[h2 w2 z]= size(A2);
A2_v = reshape(A2,h2*w2,z);
H2_v= reshape(H2,h2*w2,z);
V2_v= reshape(V2,h2*w2,z);
D2_v= reshape(D2,h2*w2,z);
 
% Display Level 1 decomposition
figure;

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

% Display Level 2 decomposition
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

% Reconstruction
 
% Full Reconstruction
Rec_X = waverec2(c,s,'db1');

% Keep only the horizontal details
CH = [0.*A2_v' 1.*H2_v' 0.*V2_v' 0.*D2_v' 1.*H1_v' 0.*V1_v' 0.*D1_v'];
Rec_XH = waverec2(CH,s,'db1');

% Keep only the vertical details
CV = [0.*A2_v' 0.*H2_v' 1.*V2_v' 0.*D2_v' 0.*H1_v' 1.*V1_v' 0.*D1_v'];
Rec_XV = waverec2(CV,s,'db1');

% Keep only all diagonal details and the approximation component
CD = [1.*A2_v' 0.*H2_v' 0.*V2_v' 1.*D2_v' 0.*H1_v' 0.*V1_v' 1.*D1_v'];
Rec_XD = waverec2(CD,s,'db1');

% Display Reconstructed Images
figure
subplot(2,2,1)
imshow(X,[]) 
title('Noisy Image');
 
subplot(2,2,2)
imshow(Rec_XH,[]) 
title('Horizontal details');

subplot(2,2,3)
imshow(Rec_XV,[]) 
title('Vertical details');

subplot(2,2,4)
imshow(Rec_XD,[]) 
title('Diagonal details+ Approximation');

%suggested denoising: Removing the highest frequqncy components  (level 1)
figure
CS = [1.*A2_v' 1.*H2_v' 1.*V2_v' 1.*D2_v' 0.*H1_v' 0.*V1_v' 0.*D1_v'];
Rec_XD = waverec2(CS,s,'db1');
imshowpair(X,Rec_XD,'montage') 
title('Suggested Denoising: Level 2 details+ Approximation');
