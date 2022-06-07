function [RES] = deconvolution(SIG,FREQ_RESP, e)
    [M, N] = size(SIG);
    RES = zeros(M, N);
    for u=1:M
        for v=1:N
            if (FREQ_RESP(u,v) < e)
                RES(u,v) = SIG(u,v);
            else
                RES(u,v) = SIG(u,v)/FREQ_RESP(u,v);
            end
        end
    end
end

