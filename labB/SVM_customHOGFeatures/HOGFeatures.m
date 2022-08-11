function [hogVect] = HOGFeatures(img, cellSize, ... 
    blockSize, blockOverlap, numBins)

% Resize the image so it may be divided into cells of cellSize
imgRes = floor(size(img) ./ cellSize) .* cellSize;
% img = imresize(img, imgRes);
img = img(1:imgRes(1), 1:imgRes(2));
[m,n] = size(img);

% Get the left bounds of each bin
binSize_deg = 180 / numBins;
bins = 0:binSize_deg:180;
bins = bins(1:numBins);

% Calculate the size of the hogVect and initialize it to all zeros
BlocksPerImage = floor((size(img)./cellSize - blockSize)./ ...
    (blockSize-blockOverlap) + 1);
N = prod([BlocksPerImage, blockSize, numBins]);
hogVect = zeros(1,N);

% Step1: Calculate the magnitude and direction of the gradients
[gradMag, gradDir] = imgradient(img, 'sobel');
% Fix the signed [-180, 180] deg gradients to [0, 180] deg.
% https://learnopencv.com/histogram-of-oriented-gradients/#:~:text=In%20other%20words%2C%20a%20gradient%20arrow%20and%20the%20one%20180%20degrees%20opposite%20to%20it%20are%20considered%20the%20same.
gradDir = abs(gradDir);

% Step2: Calculate the HOG for each cell and then normalize

% Scan over each cell and calculate its HOG
cellBins = zeros([ceil([m n] ./ cellSize),numBins]);
for i=1:cellSize(1):m
    for j=1:cellSize(2):n
        for ci=0:cellSize(1)-1
            for cj=0:cellSize(2)-1
%                 if(gradMag(i+ci,j+cj) == 0)
%                     continue;
%                 end
                angle = gradDir(i+ci,j+cj);
                % The index of the boundary to the left of current angle
                idx = floor(mod(angle, 180)/binSize_deg) + 1;
                % The index of the boundary to the right of current angle
                nidx = mod(idx, numBins) + 1;
                % Calculate the amount of magnitude that will be added to
                % the bin on the left
                idx_magn = gradMag(i+ci,j+cj) * ...
                    (mod(bins(nidx) - angle, 180)/binSize_deg);
                % Calculate the amount of magnitude that will be added to
                % the bin on the right
                nidx_magn = gradMag(i+ci,j+cj) * ...
                    (mod(angle - bins(idx),180)/binSize_deg);

                % Note that since 0deg is equivalent to 180deg, bins to the
                % left and right of the gradDir(angle) may not actually be
                % on the left and right of the angle, it is just convinient
                % to think of it this way. For example if gradDir = 170 deg
                % half of the magnitude should be added to bin with index 9
                % (160degrees), that is the idx variable and the other half
                %  should be added to bin with index 1 (0degrees), that is 
                % the nidx variable.

                % Assign the calculated magnitudes on the correct bins
                cellBins( ...
                    ceil(i/cellSize(1)), ceil(j/cellSize(2)), idx) = ...
                    cellBins( ...
                        ceil(i/cellSize(1)), ceil(j/cellSize(2)), idx) ...
                    +  idx_magn;
                cellBins( ...
                    ceil(i/cellSize(1)), ceil(j/cellSize(2)), nidx) = ...
                    cellBins( ...
                        ceil(i/cellSize(1)), ceil(j/cellSize(2)), nidx) ...
                    + nidx_magn;
            end
        end
    end
end

% Scan over each block and normalize the magnitude
[cm, cn] = size(cellBins(:,:,1));
cell_step = blockSize - blockOverlap;
block_cnt = 0;
hv_step = prod([numBins, blockSize]);
for i=1:cell_step(1):cm-1
    for j=1:cell_step(2):cn-1
        block = cellBins(i:i+blockSize(1) - 1, ...
                         j:j+blockSize(2) - 1, :);
        block = reshape(permute(block, [3 1 2]),[],1);
        hogVect(block_cnt*hv_step + 1 : (block_cnt+1)*hv_step) = ...
            block ./ sqrt(norm(block,2).^2 + 0.2);
        
        block_cnt = block_cnt + 1;
    end
end

end

