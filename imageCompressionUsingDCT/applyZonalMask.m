function [MASKED_IMG, zonalMask] = applyZonalMask(IMG, blockSize, r)
% Calculate the variance of each DCT coefficient.
% Consider every subimage as a sample of the blockSize*blockSize random
% variables it consists of. You may use those samples to calculate the
% variance at each pixel position.
% That way you are going to have blockSize*blockSize variances. Preserve
% the maximum r% of those by assigning a 1 at their location, else assign a
% 0.

% Construct the zonal mask
% Calculate the amount of pixels you will preserve for each subimage
pixAmount = (blockSize^2)*r/100;
varMat = reshape(IMG, blockSize, blockSize, []);
varMat = var(varMat, 0, 3);
zonalMask = zeros(size(varMat));
for i=1:pixAmount
    [~,ind] = max(varMat,[],'all','linear');
    [row, col] = ind2sub([blockSize blockSize], ind);
    zonalMask(row, col) = 1;
    varMat(row, col) = -1;
end

% Apply the mask to each subimage.
[M, N] = size(IMG);
MASKED_IMG = IMG;
for i=1:blockSize:M
    for j=1:blockSize:N
        MASKED_IMG(i:i+blockSize-1, j:j+blockSize-1) =...
            IMG(i:i+blockSize-1, j:j+blockSize-1).*zonalMask;
    end
end
    
end

