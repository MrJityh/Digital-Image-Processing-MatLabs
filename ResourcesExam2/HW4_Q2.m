% Parameters
close all;
A = 120;  % Amplitude
fx = 15;  % Frequency in x direction (cycles/mm)
fy = 15;  % Frequency in y direction (cycles/mm)
fs = 256;  % Sampling frequency (cycles/mm)
N=256;  % Grid size
grid_size=256;

% Create spatial grid
[x, y] = meshgrid(0:N-1, 0:N-1);

%Step-1:
%%%%%%%%
% Create sinusoidal image in x-direction:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sin_wave = A * sin(2 * pi * (fx/fs * x)) + 40;

% Plot the sinusoidal wave (spatial domain)
figure;
subplot(2,3,1)
imshow(sin_wave, []);
title('Sinusoidal Wave Image in x-direction');

% Compute 2D DFT (using fft2)
F = fftshift(fft2(sin_wave));

% Magnitude of the DFT
F_magnitude = abs(F);

% Plot the DFT magnitude (frequency domain)

%subplot(2,3,2)
%plot(F_magnitude )
subplot(2,3,4)
mesh([-grid_size/2:grid_size/2-1],[-grid_size/2:grid_size/2-1], F_magnitude );
title('2D DFT Magnitude of x-Sinusoidal Wave');
%axis([-N/2 N/2 -N/2 N/2]); % Center the axis


%Step-2:
%%%%%%%%
% Create sinusoidal image in y-direction:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sin_wave = A * sin(2 * pi * (fy/fs * y  )) + 40;

% Plot the sinusoidal wave (spatial domain)

subplot(2,3,2)
imshow(sin_wave, []);
title('Sinusoidal Wave Image in y-direction');

% Compute 2D DFT (using fft2)
F = fftshift(fft2(sin_wave));

% Magnitude of the DFT
F_magnitude = abs(F);

% Plot the DFT magnitude (frequency domain)

%subplot(2,3,2)
%plot(F_magnitude )
subplot(2,3,5)
mesh([-grid_size/2:grid_size/2-1],[-grid_size/2:grid_size/2-1], F_magnitude );
title('2D DFT Magnitude of y-Sinusoidal Wave');
%axis([-N/2 N/2 -N/2 N/2]); % Center the axis

%Step-3:
%%%%%%%%
% Create sinusoidal image in Diagonal-direction:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sin_wave = A * sin(2 * pi * (fx/fs * x + fy/fs * y  )) + 40;

% Plot the sinusoidal wave (spatial domain)

subplot(2,3,3)
imshow(sin_wave, []);
title('Sinusoidal Wave Image in z-direction');

% Compute 2D DFT (using fft2)
F = fftshift(fft2(sin_wave));

% Magnitude of the DFT
F_magnitude = abs(F);

% Plot the DFT magnitude (frequency domain)

%subplot(2,3,2)
%plot(F_magnitude )
subplot(2,3,6)
mesh([-grid_size/2:grid_size/2-1],[-grid_size/2:grid_size/2-1], F_magnitude );
title('2D DFT Magnitude of z-Sinusoidal Wave');
%axis([-N/2 N/2 -N/2 N/2]); % Center the axis
