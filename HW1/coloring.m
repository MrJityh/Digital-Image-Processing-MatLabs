I=imread('colors.jpg'); 
I3 = I;
I2 =I;
I1 = I;

I1(:,:,2:3)=0;
RED = I1;

I2(:,:,1:2) = 0;
BLUE = I2;

I3(:,:,1)=0;
I3(:,:,3)=0;
GREEN=I3;

tic;
figure;imshow(RED);
figure;imshow(BLUE);
figure;imshow(GREEN);
c = 255-RED;
m = 255-GREEN;
y = 255-BLUE;
figure;imshow(c);
figure;imshow(m);
figure;imshow(y);