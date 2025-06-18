clear; clc; close all
 
Input_CT_RGB_Im = double(imread('horse.jpg'));
X = Input_CT_RGB_Im(:,:,1);

[c,s]=wavedec2(X,2,'db1');
 
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

% Part 1: Wavelet Decomposition and Display
% Display Level 1 decomposition
figure;

subplot(4,2,1); imshow(A1,[]); title('Approximation Coef. of Level 1');
subplot(4,2,2); imshow(H1,[]); title('Horizontal detail Coef. of Level 1');
subplot(4,2,3); imshow(V1,[]); title('Vertical detail Coef. of Level 1');
subplot(4,2,4); imshow(D1,[]); title('Diagonal detail Coef. of Level 1');

% Display Level 2 decomposition
subplot(4,2,5); imshow(A2,[]); title('Approximation Coef. of Level 2');
subplot(4,2,6); imshow(H2,[]); title('Horizontal detail Coef. of Level 2');
subplot(4,2,7); imshow(V2,[]); title('Vertical detail Coef. of Level 2');
subplot(4,2,8); imshow(D2,[]); title('Diagonal detail Coef. of Level 2');

% Part 2: Reconstruct with All Decompoisition Components and visualize error
% Full Reconstruction
Rec_X = waverec2(c,s,'db1');

figure
subplot(1,3,1); imshow(X,[]); title('Input Image');

subplot(1,3,2); imshow(Rec_X,[]); title('Fully Reconstructed');

subplot(1,3,3); imshow(Rec_X-X,[]); title('Error in Reconstruction');

% Part 3-6: Only Certain Components
% Keep only approximation component
CA = [1.*A2_v' 0.*H2_v' 0.*V2_v' 0.*D2_v' 0.*H1_v' 0.*V1_v' 0.*D1_v'];
Rec_XA = waverec2(CA,s,'db1');

% Keep only the horizontal details
CH = [0.*A2_v' 1.*H2_v' 0.*V2_v' 0.*D2_v' 1.*H1_v' 0.*V1_v' 0.*D1_v'];
Rec_XH = waverec2(CH,s,'db1');

% Keep only vertical and approximation
CVA = [1.*A2_v' 0.*H2_v' 1.*V2_v' 0.*D2_v' 0.*H1_v' 1.*V1_v' 0.*D1_v'];
Rec_XVA = waverec2(CVA,s,'db1');

% Remove all Level 2 details
CL1 = [0.*A2_v' 0.*H2_v' 0.*V2_v' 0.*D2_v' 1.*H1_v' 1.*V1_v' 1.*D1_v'];
Rec_XL1 = waverec2(CL1,s,'db1');

figure;
subplot(2,2,1); imshow(Rec_XA,[]); title('Approx. Only Reconst.');
subplot(2,2,2); imshow(Rec_XH,[]); title('Horizontal Only Reconst.');
subplot(2,2,3); imshow(Rec_XVA,[]); title('Vertical + Approx. Reconst.');
subplot(2,2,4); imshow(Rec_XL1,[]); title('Level 1 Only Reconstr.');
