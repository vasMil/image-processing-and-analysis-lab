function [rec_shape] = reconstruct_shape_FD(FD, r)
    % FD are the Fourier Descriptor coefficients
    % r is the ratio of the fourier coefficients to be used for the reconstruction
    % P is the number of coefficients
    P = round(r*length(FD));
    nz = round((length(FD) - P)/2);
    zero_coef = zeros(1, nz);
    FD_alt = ifftshift([zero_coef FD(nz+1:length(FD)-nz)' zero_coef]');
    seq = ifft(FD_alt);
    x_coords = abs(round(real(seq)));
    y_coords = abs(round(imag(seq)));
    
    rec_shape = zeros(max(x_coords), max(y_coords));
    for i=1:length(x_coords)
        if(x_coords(i) == 0 || y_coords(i) == 0)
            continue;
        end
        rec_shape(x_coords(i), y_coords(i)) = 1;
    end   
end

