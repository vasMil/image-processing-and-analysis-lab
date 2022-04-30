function [k] = calcBlindWieners_k(inpImg, rows, cols)
    [M, N] = size(inpImg);
    % Add the appropriate zero padding to the image, so the kernel may act
    % upon each edge pixel.
    if(mod(M,rows))
        reqRows = ceil(M/rows)*rows - M;
        usedRows = rows - reqRows;
        start = M-usedRows-reqRows;
        inpImg = [inpImg; inpImg(start+1:start+reqRows,:)];
    end
    if(mod(N,cols))
        reqCols = ceil(N/cols)*cols - N;
        usedCols = cols - reqCols;
        start = N-usedCols- reqCols;
        inpImg = [inpImg inpImg(:,start+1:start+reqCols)];
    end
    % Iterate through all the pixels that contain true information, find
    % the DFT
    [P, Q] = size(inpImg);
    k = zeros(P,Q);
    for x=1:rows:P
        for y=1:cols:Q
            % Approximate SNR - ?in the spatial domain?
            block = inpImg(x:x+rows-1,y:y+rows-1);
            signal = mean(block,'all');
            noise = std(block,0,'all');
            if (noise == 0 || signal == 0)
                k(x:x+rows-1,y:y+rows-1) = 0;
            else
                k(x:x+rows-1,y:y+rows-1) = noise/signal;
            end
        end
    end
    k = k(1:M,1:N);
end

