function [numC, denC, kp, Ti, Td] = controlador(num, den, tipo, zc2, sd, sigma, wd)
    Ti = 0;
    Td = 0;
    kp = 0;

    %% DEFINIR TIPO DE CONTROL
    switch tipo
        case 'P'
            numC2 = 1;
            denC = 1;
        case 'I'
            numC2 = 1;
            denC = [1 0];
        case 'PI'
            numC2 = 1;
            denC = [1 0];
        case 'PD'
            numC2 = 1;
            denC = [1 0];
        case 'PID'
            numC2 = [1 zc2];
            denC = [1 0];
        case 'ADELANTO'
            numC2 = 1;
        case 'ATRASO'
            numC2 = 1;
    end

    %% CONDICIÓN DE ÁNGULO
    if strcmp(tipo, 'PI') || strcmp(tipo, 'PD') || strcmp(tipo, 'PID')
        k = 0;
        phi = (2*k+1)*180 - rad2deg(angle(polyval(numC2, sd))) - rad2deg(angle(polyval(num, sd))) ...
            + rad2deg(angle(polyval(denC, sd))) + rad2deg(angle(polyval(den, sd)));
        zc1 = sigma + wd/tand(phi);
        numC1 = [1 zc1];
    elseif strcmp(tipo, 'ATRASO') || strcmp(tipo, 'ADELANTO')
        k = 0;
        phi = (2*k+1)*180 - rad2deg(angle(polyval(numC2, sd))) - rad2deg(angle(polyval(num, sd))) ...
             + rad2deg(angle(polyval(den, sd)));
        alpha_b = rad2deg(angle(polyval([1 zc2], sd)));
        beta_b = alpha_b - phi;
        pc=sigma+(wd/tand(beta_b));
        numC1 = [1 zc2];
        denC = [1 pc];
    end 

    %% CONDICIÓN DE MAGNITUD
    K = (abs(polyval(denC, sd)) * abs(polyval(den, sd))) / (abs(polyval(num, sd)) * abs(polyval(numC1, sd)) * ...
    abs(polyval(numC2, sd)));

    numC = K * conv(numC1, numC2);

    %% HALLANDO kp, Ti, Td
    switch tipo
        case 'P'
            kp = K;
        case 'I'
            ki = K;
        case 'PI'
            kp = K;
            Ti = 1/zc1;
        case 'PD'
            Td = 1/zc1;
            kd = K;
            kp = K/Td;
        case 'PID'
            Td = 1/(zc1 + zc2);
            Ti = (zc1 + zc2)/(zc1*zc2);
            kd = K;
            kp = kd/Td;
        case 'ADELANTO'
            alpha = zc2/pc;
        case 'ATRASO'
            alpha = zc2/pc;
    end
end