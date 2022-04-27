function [outImg] = alternamePixelSigns(inpImg)
    [M, N] = size(inpImg);
    outImg = inpImg;
    for i=1:M
        for j=1:N
            if ~mod(i+j,2)
                outImg(i,j) = (-1).*inpImg(i,j);
            end
        end
    end
end

