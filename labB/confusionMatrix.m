function [confMat] = confusionMatrix(predictions, actual_labels)


if(~isequal(size(predictions), size(actual_labels)))
    error("Size of predictions and the actual_labels must be equal");
end

confMat = zeros(10,10);

for i=1:length(predictions)
    col = predictions(i) + 1;
    row = actual_labels(i) + 1;
    confMat(row, col) = confMat(row, col) + 1;
    if col ~= row
        confMat(col,row) = confMat(col, row) + 1;
    end
end

heatmap(confMat, ...
    "Title", "Confusion matrix as a heatmap in logaritmic scale", ...
    "ColorScaling", "log", ...
    "XDisplayLabels", (0:9), ...
    "YDisplayLabels", (0:9));
end
