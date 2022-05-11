function [MASKED_IMG, thresholdMask] =...
    applyThresholdMask(IMG, blockSize, r)

[M, N] = size(IMG);

thresholdMask = zeros(M, N);
for i=1:blockSize:M
    for j=1:blockSize:N
        % Find the threshold such that the mask preserves r% of the DCT 
        % coefficients
        sortPix = sort(...
            reshape(IMG(i:i+blockSize-1,j:j+blockSize-1),1,[]), 'descend');
        thres = sortPix(round(length(sortPix)*r/100));
        thresholdMask(i:i+blockSize-1,j:j+blockSize-1) =...
            IMG(i:i+blockSize-1,j:j+blockSize-1) >= thres;
    end
end
    MASKED_IMG = IMG.*thresholdMask;
end

