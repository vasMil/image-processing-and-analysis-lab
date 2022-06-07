function [outImg] = rowColumn_fft(inpImg)
% https://www.mathworks.com/help/matlab/ref/fft.html#:~:text=dim%20%E2%80%94%20Dimension%20to%20operate%20along
    % Apply fft at each row of the matrix
    outImg = fft(inpImg,[],2);
    % Apply fft at each column of the result above
    outImg = fft(outImg,[],1);
end

