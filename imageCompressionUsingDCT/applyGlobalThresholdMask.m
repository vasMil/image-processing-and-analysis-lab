function [MASKED_IMG, globalThresholdMask] =...
    applyGlobalThresholdMask(IMG, blockSize, r)

[M, N] = size(IMG);

globalThresholdMask = zeros(M, N);

% Find the global threshold
sortPix = sort(abs(reshape(IMG,1,[])), 'descend');
thres = sortPix(round(length(sortPix)*r/100));

% Create the subimage masks
for i=1:blockSize:M
    for j=1:blockSize:N        
        globalThresholdMask(i:i+blockSize-1,j:j+blockSize-1) =...
            abs(IMG(i:i+blockSize-1,j:j+blockSize-1)) >= thres;
    end
end

% Apply the global threshold filter to every subimage
MASKED_IMG = IMG.*globalThresholdMask;

end

