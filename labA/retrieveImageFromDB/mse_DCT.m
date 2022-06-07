function [mse_DCT] = mse_DCT(image_test_dct, image_db,...
    preserve_perc, blocksize)

    [M,N,d] = size(image_db);
    image_db_dct = zeros(M,N,d);
    for i=1:d
        % Move to the frequency domain
        image_db_dct(:,:,i) = dct2(im2double(image_db(:,:,i)));
        % Apply the threshold filter
        image_db_dct(:,:,i) = applyGlobalThresholdMask(...
            image_db_dct(:,:,i),blocksize,preserve_perc);
    end
    mse_DCT = immse(image_test_dct, image_db_dct);
end

