function [FD] = calc_FD(img, min_expect_coef)
% Given an image as an input it calculates the Fourier Descriptors
skip_pix = 0;
[x, y] = getInitialPoint(img);

% Boundary Following - Tracing
coords = bwtraceboundary(img, [x y], 'E');
while(length(coords) < min_expect_coef)
    skip_pix = skip_pix + 1;
    [x, y] = getInitialPoint(img, skip_pix);
    coords = bwtraceboundary(img, [x y], 'E');
end
% Remove the last pixel, since it is the same as the starting pixel.
% That way the number of coefficients is even, as noted in
% Gonzalez, Digital Image Processing, page 837
coords = coords(1:length(coords)-1,:);
x_seq = coords(:,1);
y_seq = coords(:,2);

% Apply the FFT to the sequence from previous step
seq = x_seq + 1i.*y_seq;
FD = fftshift(fft(seq));
end

