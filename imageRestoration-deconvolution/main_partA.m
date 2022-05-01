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
WIENER_k = 1./(1+k);
% Apply the filter
LENNA_k = WIENER_k.*LENNA_GAUSS;

% Construct the filter, approximating SNR, using blocking
K = calcBlindWieners_k(lenna_gauss,3,3);
WIENER_blocking = 1./(1+K);
% Apply the filter
LENNA_blocking = WIENER_blocking.*LENNA_GAUSS;

% Get back to the spatial domain
lenna_smooth = ifft2(ifftshift(LENNA_SMOOTH));
lenna_smooth = lenna_smooth(1:M, 1:N);

lenna_k = ifft2(ifftshift(LENNA_k));
lenna_k = lenna_k(1:M, 1:N);

lenna_blocking = real(ifft2(ifftshift(LENNA_blocking)));
lenna_blocking = lenna_blocking(1:M, 1:N);

% Use matlabs wiener2 function
lenna_mat = wiener2(lenna_gauss, [5 5], variance);
lenna_mat = lenna_mat(1:M, 1:N);
lenna_blindMat = wiener2(lenna_gauss, [5 5]);
lenna_blindMat= lenna_blindMat(1:M,1:N);

% Remove the zero padding
dlenna_r = dlenna_r(1:M,1:N);
lenna_gauss = lenna_gauss(1:M,1:N);

% Plot
figure(1);
subplot(1,2,1);
imshow(lenna_r, []);
title("Original Image");
subplot(1,2,2);
imshow(lenna_gauss, []);
title(strcat("AWGN of ", num2str(snr_db), "db"));

figure(2);
subplot(3,2,1);
imshow(lenna_smooth, []);
title("Wiener filter, using S_n/S_f");
subplot(3,2,2);
imshow(lenna_k, []);
title(strcat("Blind Wiener filter, using k = ", num2str(k)));
subplot(3,2,3);
imshow(lenna_blocking, []);
title("Bling Wiener filter, using blocking approx. of the SNR");
subplot(3,2,4);
imshow(lenna_mat, []);
title("Using wiener2, supplying the noise variance");
subplot(3,2,[5 6]);
imshow(lenna_blindMat, []);
title("Using wiener2, without the variance");

MSE_noise = mean((dlenna_r-lenna_gauss).^2,'all');
MSE_smooth = mean((dlenna_r-lenna_smooth).^2,'all');
MSE_k = mean((dlenna_r-lenna_k).^2,'all');
MSE_blocking = mean((dlenna_r-lenna_blocking).^2,'all');
MSE_mat = mean((dlenna_r-lenna_mat).^2,'all');
MSE_blindMat = mean((dlenna_r-lenna_blindMat).^2,'all');

disp(strcat("MSE_noise = ", num2str(MSE_noise)));
disp(strcat("MSE_smooth = ", num2str(MSE_smooth)));
disp(strcat("MSE_k = ", num2str(MSE_k)));
disp(strcat("MSE_blocking = ", num2str(MSE_blocking)));
disp(strcat("MSE_mat = ", num2str(MSE_mat)));
disp(strcat("MSE_blindMat = ", num2str(MSE_blindMat)));