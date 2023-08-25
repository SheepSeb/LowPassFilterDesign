function w = lanczos(M,L)
    w = zeros(M,1);
    for n = 1:M
        w(n) = (sin(2*pi * (2*n-M+1)/(2*(M-1))) / (2*pi * ((2*n-M + 1)/(2*(M-1)))))^L;
    end
end