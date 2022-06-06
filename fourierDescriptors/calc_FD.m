function [FD] = calc_FD(img)
[M, N] = size(img);
% Given an image as an input it calculates the Fourier Descriptors
% Get the uppermost-leftmost point
x = 1; y = 1;
cur_pix = img(x,y);
while cur_pix ~= 1
    y = y + 1;
    if y > N
        y = 1;
        x = x + 1;
        if x > M
            error("All pixels in image are 0");
        end
    end
    cur_pix = img(x,y);
end

% Boundary Following - Tracing
coords = bwtraceboundary(img, [x y], 'E');
x_seq = coords(:,1);
y_seq = coords(:,2);

% Apply the FFT to the sequence from previous step
seq = x_seq + 1i.*y_seq;
FD = fft(seq);
end

