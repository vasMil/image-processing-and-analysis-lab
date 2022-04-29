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

close all;
