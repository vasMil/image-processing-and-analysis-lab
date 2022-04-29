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

[gauss_movAvgMSE, gauss_medianMSE, gauss_movAvgSNR, gauss_medianSNR] =...
    filterPlotAndStatistics(tiger, tiger_gauss, 3, 3, "AWGN");

% Construct noisy images - Salt & Pepper
tiger_sp = imnoise(tiger, 'salt & pepper', d_sp);

[sp_movAvgMSE, sp_medianMSE, sp_movAvgSNR, sp_medianSNR] =...
    filterPlotAndStatistics(tiger, tiger_sp, 5, 3, "Salt & Pepper");

% Add both Gaussian and Salt & Pepper noise
tiger_noisy = imnoise(tiger_gauss, 'salt & pepper', d_sp);

% First apply the median filter in order to get rid of the salt & pepper
% noise. This way when you use the moving average kernel you won't have
% outliers offseting the neighborhood average.
tiger_noisy_med = medfilt2(tiger_noisy, [3 3]);
tiger_filtered = movmean(tiger_noisy_med, 3);

% Calculate some statistics
MSE = mean((tiger - tiger_filtered).^2, 'all');
SNR = 10*log10(sum(tiger.^2, 'all')/...
    sum((tiger-tiger_filtered).^2,'all'));

% Plot the results
figure("Name", "AWGN and Impulse Noise");
subplot(2,2,1);
imshow(tiger);
title("Initial Image");
subplot(2,2,2);
imshow(tiger_noisy);
title("Noisy Image");
subplot(2,2,3);
imshow(tiger_noisy_med);
title("Noisy Image after Median filter");
subplot(2,2,4);
imshow(tiger_filtered);
title("Noisy Image after successively applying a Median and a Moving average filter");

