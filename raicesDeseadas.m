function [sd, sigma, wd] = raicesDeseadas(tss, chi)

    %% CALCUMALOS Y DEVOLVEMOS LOS VALORES DE sd, sigma, wn
    sigma = 5/tss;
    wn = sigma/chi;
    wd = wn*sqrt(1-chi^2);
    sd = -sigma + 1i*wd;

end