close all;
clear;
clc;

moon = imread('..\Images\exercise1\moon.jpg');
[M, N, d] = size(moon);

% Why does the image have three dimensions?
% It may be that each plane represents one of the three colors r,g,b
t0 = all(moon(:,:,1) == moon(:,:,2),'all');
t1 = all(moon(:,:,1) == moon(:,:,3),'all');
if (t0 == t1)
    disp("All 3 planes have the same values");
end
% But if that is the case then why are all planes identical?
% Answer:
% https://www.mathworks.com/matlabcentral/answers/155029-trying-to-understand-the-image-matrix#answer_151862

% How do I handle rgb images?
% For example applying DFT?
% https://stackoverflow.com/a/9827229/14958480
% Applying filter:
% https://www.mathworks.com/matlabcentral/answers/616753-applying-2d-filter-on-rgb-image
% Essentially I operate upon each channel separately.

% Preprocessing
% Since it is a grayscale image I may only hold on to one of the channels
moon_r = moon(:,:,1);
% Histogram Equalization
% In the case of a colored image, it is still possible to apply histogram
% equalization to each layer independently, but I would get significant
% changes on the color balance of the image.
% Sources:
% https://en.wikipedia.org/wiki/Histogram_equalization#:~:text=The%20above%20describes,applying%20the%20algorithm.
% https://towardsdatascience.com/histogram-equalization-5d1013626e64#:~:text=A%20color%20histogram,of%20the%20image.
moon_r_equ = histogramEqualization(moon_r, 256);

figure;
subplot(2,2,1);
histogram(moon_r, 256);
title("Initial histogram");
subplot(2,2,2);
imshow(moon_r,[])
title("Initial image");

subplot(2,2,3);
histogram(moon_r_equ, 256);
title("histogram after equalization")
subplot(2,2,4);
imshow(moon_r_equ,[])
title("Image after histogram equalization")

% Apply DFT property Gonzalez chapter 4, 4.6, page 251 (fourth edition)
% Circular Frequency Shift is the property used to translate frequency 
% point (0,0) to the center of the frequency rectangle
moon_r_equ_cent = alternatePixelSigns(moon_r_equ);
figure;
imshow(moon_r_equ_cent, []);
title("Image after Histogram Equalization and Circular Frequency Shift");

% Add zero padding (M by N => 2*M by 2*N) Gonzales Chap. 4, 4.6 page 257
% (fourth edition)
% required for later filtering (Reminder: Multiplication of the DFT of two
% signals is their circular convolution in the time domain, thus I need to
% fix conditions so the resulting circular conv is the same as linear conv
moon_pad = zeros(2*M, 2*N);
moon_pad(1:M,1:N) = moon_r_equ_cent;

% Compute 2D DFT, using row-column algorithm
MOON_PAD = rowColumn_fft(moon_pad);
% Plot the magnitude
figure;
subplot(1,2,1);
imshow(abs(MOON_PAD), []);
title("DFT Magnitude");

subplot(1,2,2);
imshow(log(abs(MOON_PAD)), []);
title("DFT Magnitude in logarithmic scale");

% Create a lowpass Gaussian filter
H = GLPF(2*M, 2*N, 40);

% Apply the filter (on the frequency domain)
MOON_BLURR_PAD = MOON_PAD.*H;

% Return back to the spatial domain
% I may use the forward 2D fft algorithm on the complex conjugate of the
% signal on the frequency domain, that is F*(u,v). This will return
% MNf*(x,y). Thus taking the complex conjugate of that and dividing the
% result by MN, results to f(x,y). (4th edition, Ch. 4, 4.11 page 304)
moon_blur = rowColumn_fft(conj(MOON_BLURR_PAD));

% Due to computational inaccuracies IDFT results to a complex matrix in the
% spatial domain, even though the input image is real and the
% Gaussian LowPass Filter is both real and symmetric, thus I only take the
% real part of the IDFT.
% Gonzales (4th edition, Ch. 4, 4.7 page 267)
moon_blur = real(moon_blur);
% Note that if that was not the case, that is I knew that the IDFT would
% result to a complex matrix, I should take the conj(moon_blur). In reality
% I could do the same here but it is not necessary, since the complex
% conjugate of a real number is that number.

% Restore the position (0,0) to the top left corner of the frequency
% rectangle.
moon_blur = alternatePixelSigns(moon_blur(1:M,1:N));

% Devide with MN
% REMINDER: The size of the matrix in the frequency domain is not [M, N]
% but [P, Q] == [2*M, 2*N], thus you need to divide with 4*M*N.
% Gonzales' formula (4-158, page 304 of the fourh edition) is the general
% case formula!
moon_blur = moon_blur/(4*M*N);

% Plot the result
figure;
imshow(moon_blur, []);
title("Moon after Histogram Equalization and Lowpass filter");
