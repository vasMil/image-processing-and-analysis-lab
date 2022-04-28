close all;
clear;
clc;

load("../Images/exercise3/tiger.mat");

snr_db = 15;
[M, N] = size(tiger);

% Construct noisy images
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
tiger_median = medfilt2(tiger_gauss, [3 3]);
figure;
subplot(2,2,1);
imshow(tiger);
title("Initial Image");
subplot(2,2,2);
imshow(tiger_gauss);
title("Image with AWGN");
subplot(2,2,3);
imshow(tiger_movAvg);
title("After moving average filter");
subplot(2,2,4);
imshow(tiger_median);
title("After median filter");
