function [filtMat] = GLPF(P, Q, D0)
    filtMat = zeros(P,Q);
    for u=1:P
        for v=1:Q
            dist = (u-P/2)^2 + (v-Q/2)^2;
            filtMat(u,v) = exp(1)^(-dist/(2*D0^2));
        end
    end
end

