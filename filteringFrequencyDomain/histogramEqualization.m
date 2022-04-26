function [mappedImg] = histogramEqualization(inpImg, L)
    [M,N] = size(inpImg);
    nPix = M*N;
    % Calculate the normalized image histogram
    p = zeros(1,L);
    for i=1:L
        p(i) = sum(inpImg(:,:) == i, 'all')/nPix;
    end
    
    % Calculate the intensity levels to map onto
    s = zeros(1,L);
    for k=1:L
        s(k) = round((L-1)*sum(p(1:k)));
    end
    map = containers.Map(uint32(0:L-1), uint8(s));
    
    % Map image
    mappedImg = zeros(M,N);
    for i=1:M
        for j=1:N
            mappedImg(i,j) = map(inpImg(i,j));
        end
    end
end