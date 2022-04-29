close all;
clear;
clc;

load("../Images/exercise3/tiger.mat");

snr_db = 15;
d_sp = 0.2;
[M, N] = size(tiger);

% Construct noisy images - Additive White Gaussian Noise
variance = 10^-(snr_db/10)*sum(tiger.^2, 'all')/(M*N-1);
tiger_gauss = imnoise(tiger, 'gaussian', 0, variance);

figure;
subplot(1,2,1);
imshow(tiger);
title("Initial Image");
subplot(1,2,2);
imshow(tiger_gauss);
title("Image with AWGN");

% Filter noisy images
tiger_movAvg = movmean(tiger_gauss, 5);
tiger_median = medfilt2(tiger_gauss, [5 5]);
figure("Name", "Gaussian Noise");
subplot(2,2,1);
imshow(tiger);
title("Initial Image");
subplot(2,2,2);
imshow(tiger_gauss);
title("Image with AWGN");
subplot(2,2,3);
imshow(tiger_movAvg);
title("After 5x5 moving average filter");
subplot(2,2,4);
imshow(tiger_median);
title("After 5x5 median filter");


% Construct noisy images - Salt & Pepper
tiger_sp = imnoise(tiger, 'salt & pepper', d_sp);

figure;
subplot(1,2,1);
imshow(tiger);
title("Initial Image");
subplot(1,2,2);
imshow(tiger_sp);
title("Image with impulse noise");

% Filter noisy images
tiger_sp_movAvg = movmean(tiger_sp, 9);
tiger_sp_median = medfilt2(tiger_sp, [4 4]);
figure("Name", "Salt & Pepper");
subplot(2,2,1);
imshow(tiger);
title("Initial Image");
subplot(2,2,2);
imshow(tiger_sp);
title("Image with impulse noise");
subplot(2,2,3);
imshow(tiger_sp_movAvg);
title("After 9x9 moving average filter");
subplot(2,2,4);
imshow(tiger_sp_median);
title("After 4x4 median filter");