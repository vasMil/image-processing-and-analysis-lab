close all;
clear;
clc;

lenna = imread("../Images/exercise5/lenna.jpg");

[M, N, d] = size(lenna);

lenna = rgb2gray(lenna);
lenna = im2double(lenna);

% lenna = imnoise(lenna, 'gaussian', 0, 0.05);

impulse = zeros(M,N);
impulse(1,1) = 1;
cd ../
lenna_psf = psf(lenna);
impulse_psf = psf(impulse);
cd imageRestoration-deconvolution/

% Get the Frequency resonse of the psf
H = fftshift(fft2(impulse_psf));

% Move to the frequency domain
LENNA_PSF = fftshift(fft2(lenna_psf));

% Blind deconvolution
LENNA = LENNA_PSF./H;

% Limit - smooth transition with BLPF
Butter = BLPF(M,N,70,10);
LENNA_BUTTER = LENNA.*Butter;
% LENNA_BUTTER = deconvolution(LENNA_PSF,H,.9);

% Get back to the spatial domain
lenna_inv = real(ifft2(ifftshift(LENNA)));
lenna_butter = real(ifft2(ifftshift(LENNA_BUTTER)));

% Normalize intensities between [0,1]
lenna_inv = mat2gray(lenna_inv);
lenna_butter = mat2gray(lenna_butter);

% Calculate MSE
MSE_inv = mean((lenna-lenna_inv).^2, 'all');
MSE_butter = mean((lenna-lenna_butter).^2, 'all');

% Plot
figure(1);
subplot(1,2,1);
imshow(lenna);
title("Original Image");
subplot(1,2,2);
imshow(lenna_psf);
title("After psf");

figure(2);
subplot(2,2,1);
imshow(impulse);
title("2D impulse function");
subplot(2,2,2);
imshow(impulse_psf);
title("Impulse after psf");
subplot(2,2,3);
imshow(log(abs(H)));
title("Frequency response");
subplot(2,2,4);
imshow(lenna_inv);
title("Lenna after inverse filter");

figure(3);
subplot(1,2,1);
imshow(lenna_inv);
title("Apply only inverse filter");
subplot(1,2,2);
imshow(lenna_butter);
title("Apply inverse and butterworth filter");