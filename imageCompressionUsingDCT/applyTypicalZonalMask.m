function [MASKED_IMG, typicalZonalMask] =... 
    applyTypicalZonalMask(IMG, blockSize, r)
% Gonzalez 4th edition Ch. 8 page 584
% "Coefficients of maximum variance usually are located around the origin
% of an image transform, resulting in the typical zonal mask"

% Construct the mask
% Calculate the amount of pixels you will preserve for each subimage
pixAmount = floor((blockSize^2)*r/100);
% Convert pixAmount to a circle radius
radius = min([floor(-1+sqrt(1+2*pixAmount)), blockSize]);
typicalZonalMask = zeros(blockSize, blockSize);
for i=1:blockSize
    for j=1:blockSize
        if (i+j) <= radius+1
            typicalZonalMask(i,j) = 1;
        end
    end
end
% Append the remaining coefficients one by one at the end of each row,
% until none are left
remainCoef = pixAmount - sum(typicalZonalMask, 'all');

i = 0;
row = 1;
col = radius + 1;
while i < remainCoef
    if(row > blockSize)
        temp = row;
        row = col + 1;
        col = temp;
    elseif(col > blockSize)
        row = row + 1;
        col = col - 1;
    else
        typicalZonalMask(row, col) = 1;
        row = row + 1;
        col = col - 1;
        i = i + 1;
    end
end

% Apply the mask to each subimage.
[M, N] = size(IMG);
MASKED_IMG = IMG;
for i=1:blockSize:M
    for j=1:blockSize:N
        MASKED_IMG(i:i+blockSize-1, j:j+blockSize-1) =...
            IMG(i:i+blockSize-1, j:j+blockSize-1).*typicalZonalMask;
    end
end

end

