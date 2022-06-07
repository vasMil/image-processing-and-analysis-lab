function [movAvgMSE, medianMSE, movAvgSNR, medianSNR,...
    movAvgImg, medianImg] =...
    filterPlotAndStatistics(...
    pureImg, noisyImg,...
    movAvgKernelSize, medianKernelSize,...
    typeOfNoise...
    )
    
    % Filter noisy images using the kernel sizes defined in the args
    movAvgImg = movmean(noisyImg, movAvgKernelSize);
    medianImg = medfilt2(noisyImg, [medianKernelSize medianKernelSize]);
    
    % Calculate statistics
    movAvgMSE = mean((pureImg - movAvgImg).^2, 'all');
    medianMSE = mean((pureImg - medianImg).^2, 'all');
    
    movAvgSNR = 10*log10(sum(pureImg.^2, 'all')/...
        sum((pureImg-movAvgImg).^2,'all'));
    medianSNR = 10*log10(sum(pureImg.^2, 'all')/...
        sum((pureImg-medianImg).^2,'all'));
    
    % Plot
    figure;
    subplot(1,2,1);
    imshow(pureImg);
    title("Initial Image");
    subplot(1,2,2);
    imshow(noisyImg);
    title(strcat("Image with ", typeOfNoise));

    figure("Name", typeOfNoise);
    subplot(2,2,1);
    imshow(pureImg);
    title("Initial Image");
    subplot(2,2,2);
    imshow(noisyImg);
    title(strcat("Image with ", typeOfNoise));
    subplot(2,2,3);
    imshow(movAvgImg);
    title(strcat("After ", string(movAvgKernelSize), "x",...
        string(movAvgKernelSize), " moving average filter"));
    subplot(2,2,4);
    imshow(medianImg);
    title(strcat("After ", string(medianKernelSize), "x",...
        string(medianKernelSize), " median filter"));

end

