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

% Construct the Wiener filter - using the knowledge of S_n
WIENER = S_f./(S_f+S_n);
% Apply the filter
LENNA_WIENER = WIENER.*LENNA_GAUSS;

% Construct the filter without using S_n
WIENER_k = 1./(1+k);
% Apply the filter
LENNA_k = WIENER_k.*LENNA_GAUSS;

% Construct the filter, approximating SNR, using an area of the image
% that is somewhat smooth.
figure(10);
title("Select the area you want to approximate SNR with")
subplot(1,2,1);
imshow(lenna_gauss);
subplot(1,2,2);
imshow(lenna_r);
g = round(ginput(2));
g = double(lenna_gauss(g(1,2):g(2,2),g(1,1):g(2,1)));
close 10;
S_f_approx = mean(g(:));
S_n_approx = std(g(:));
WIENER_AREA_APPROX = S_f_approx./(S_f_approx+S_n_approx);
LENNA_AREA_APPROX = WIENER_AREA_APPROX.*LENNA_GAUSS;

% Construct the filter, approximating SNR, using blocking
K = calcBlindWieners_k(lenna_gauss,3,3);
WIENER_blocking = 1./(1+K);
% Apply the filter
LENNA_blocking = WIENER_blocking.*LENNA_GAUSS;

% Get back to the spatial domain
lenna_wiener = ifft2(ifftshift(LENNA_WIENER));
lenna_wiener = lenna_wiener(1:M, 1:N);

lenna_k = ifft2(ifftshift(LENNA_k));
lenna_k = lenna_k(1:M, 1:N);

lenna_area_approx = ifft2(ifftshift(LENNA_AREA_APPROX));
lenna_area_approx = lenna_area_approx(1:M, 1:N);

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
imshow(lenna_wiener, []);
title("Wiener filter, using S_n/S_f");
subplot(3,2,2);
imshow(lenna_k, []);
title(strcat("Blind Wiener filter, using k = ", num2str(k)));
subplot(3,2,3);
imshow(lenna_area_approx, []);
title("Using a smooth area of the noisy image to approximate SNR");
subplot(3,2,4);
imshow(lenna_blocking, []);
title("Bling Wiener filter, using blocking approx. of the SNR");
subplot(3,2,5);
imshow(lenna_mat, []);
title("Using wiener2, supplying the noise variance");
subplot(3,2,6);
imshow(lenna_blindMat, []);
title("Using wiener2, without the variance");

MSE_noise = immse(dlenna_r, lenna_gauss);
MSE_wiener = immse(dlenna_r, lenna_wiener);
MSE_k = immse(dlenna_r, lenna_k);
MSE_area_approx = immse(dlenna_r, lenna_area_approx);
MSE_blocking = immse(dlenna_r, lenna_blocking);
MSE_mat = immse(dlenna_r, lenna_mat);
MSE_blindMat = immse(dlenna_r, lenna_blindMat);

disp(strcat("MSE_noise = ", num2str(MSE_noise)));
disp(strcat("MSE_wiener = ", num2str(MSE_wiener)));
disp(strcat("MSE_k = ", num2str(MSE_k)));
disp(strcat("MSE_area_approx = ", num2str(MSE_area_approx)));
disp(strcat("MSE_blocking = ", num2str(MSE_blocking)));
disp(strcat("MSE_mat = ", num2str(MSE_mat)));
disp(strcat("MSE_blindMat = ", num2str(MSE_blindMat)));