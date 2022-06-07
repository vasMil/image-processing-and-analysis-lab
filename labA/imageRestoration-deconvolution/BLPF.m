function [freqResp] = BLPF(P, Q, D0, n)
    freqResp = zeros(P,Q);
    for u=1:P
        for v=1:Q
            dist = (u-P/2)^2 + (v-Q/2)^2;
            freqResp(u,v) = D0^(2*n) / (D0^(2*n) + dist^n);
        end
    end
end

