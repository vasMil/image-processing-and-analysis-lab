function [x,y] = getInitialPoint(img, skip)
    if nargin < 2
        skip = 0;
    end
    [M, N] = size(img);
    % Get the uppermost-leftmost point
    x = 1; y = 1;
    cur_pix = img(x,y);
    while skip > 0 || cur_pix ~= 1
        if cur_pix == 1
            skip = skip - 1;
        end
        y = y + 1;
        if y > N
            y = 1;
            x = x + 1;
            if x > M
                error("All pixels in image are 0");
            end
        end
        cur_pix = img(x,y);
    end
end

