close all;
clear;
clc;

load("../Images/exercise3/tiger.mat");

snr_db = 15;
[M, N] = size(tiger);

figure;
imshow(tiger);
title("Initial Image");

% Construct noisy images
variance = 10^-(snr_db/10)*sum(tiger.^2, 'all')/(M*N-1);
tiger_gauss = imnoise(tiger, 'gaussian', 0, variance);

figure;
imshow(tiger_gauss);