close all;
clear;
clc;

lenna = imread("../Images/exercise5/lenna.jpg");

snr_db = 10; % SNR in db for AWGN
k = 0.11; % The constant with which I will approximate the Wiener filter.
[M, N, d] = size(lenna);

% Again I notice all three channels have the same values so I may work
% on one of them.
lenna_r = lenna(:,:,1);

% Add zero padding
% dlenna_r = zeros(2*M, 2*N);
% Fix pixel intensities in range [0,1], required for imnoise().
dlenna_r(1:M,1:N) = im2double(lenna_r);

variance = 10^-(snr_db/10)*sum(dlenna_r.^2, 'all')/(M*N-1);
lenna_gauss = imnoise(dlenna_r, 'gaussian', 0, variance);

% Move to the frequency domain
LENNA_GAUSS = fftshift(fft2(lenna_gauss));
imshow(log(abs(LENNA_GAUSS)), []);

% Calculate power spectrums
S_n = abs(fftshift(fft2(dlenna_r - lenna_gauss))).^2;
S_f = abs(fftshift(fft2(dlenna_r))).^2;

% Construct the smoothing filter Wiener - using the knowledge of S_n
SMOOTH_WIENER = S_f./(S_f+S_n);
% Apply the filter
LENNA_SMOOTH = SMOOTH_WIENER.*LENNA_GAUSS;

% Construct the filter without using S_n
% k = 3;
% k = calcBlindWieners_k(lenna_gauss,k,k);
SMOOTH_WIENER_k = 1./(1+k);
LENNA_SMOOTH_k = SMOOTH_WIENER_k.*LENNA_GAUSS;

% Get back to the spatial domain
lenna_smooth = ifft2(ifftshift(LENNA_SMOOTH));
lenna_smooth = lenna_smooth(1:M, 1:N);

lenna_smooth_k = real(ifft2(ifftshift(LENNA_SMOOTH_k)));
% lenna_smooth_k = wiener2(lenna_gauss, [5 5], variance);
lenna_smooth_k = lenna_smooth_k(1:M, 1:N);

% Plot
figure;
subplot(2,2,1);
imshow(lenna_r, []);
title("Original Image");
subplot(2,2,2);
imshow(lenna_gauss(1:M,1:N), []);
title(strcat("AWGN of ", num2str(snr_db), "db"));
subplot(2,2,3);
imshow(lenna_smooth, []);
title("Using Wiener with knowledge to the power of the noise");
subplot(2,2,4);
imshow(lenna_smooth_k, []);
title("Using approximation of the Wiener filter");

MSEsk = mean((dlenna_r(1:M,1:N)-lenna_smooth_k).^2,'all')
MSEs = mean((dlenna_r(1:M,1:N)-lenna_smooth).^2,'all')
MSE = mean((dlenna_r(1:M,1:N)-lenna_gauss(1:M,1:N)).^2,'all')