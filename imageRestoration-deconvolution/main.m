close all;
clear;
clc;

lenna = imread("../Images/exercise5/lenna.jpg");

snr_db = 10;
[M, N, d] = size(lenna);

% Again I notice all three channels have the same values so I may work
% on one of them.
lenna_r = lenna(:,:,1);

% Add zero padding
dlenna_r = zeros(2*M, 2*N);
% Fix pixel intensities in range [0,1], required for imnoise().
dlenna_r(1:M,1:N) = im2double(lenna_r);

variance = 10^-(snr_db/10)*sum(dlenna_r.^2, 'all')/(M*N-1);
lenna_gauss = imnoise(dlenna_r, 'gaussian', 0, variance);

% Move to the frequency domain
LENNA_GAUSS = fftshift(fft2(lenna_gauss));
imshow(log(abs(LENNA_GAUSS)), []);

% Calculate power spectrums
S_n = fftshift(fft2(dlenna_r - lenna_gauss)).^2;
S_f = fftshift(fft2(dlenna_r)).^2;

% Construct the smoothing filter Wiener
SMOOTH_WIENER = S_f./(S_f+S_n);
% Apply the filter
LENNA_SMOOTH = SMOOTH_WIENER.*LENNA_GAUSS;

% Get back to the spatial domain
lenna_smooth = real(ifft2(ifftshift(LENNA_SMOOTH)));
imshow(lenna_smooth(1:M,1:N), []);

% Plot the original and the noisy image
figure;
subplot(1,2,1);
imshow(lenna_r, []);
title("Original Image");
subplot(1,2,2);
imshow(lenna_gauss, []);
title(strcat("AWGN of ", num2str(snr_db), "db"));