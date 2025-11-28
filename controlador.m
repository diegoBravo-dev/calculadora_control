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
            denC = 1;
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
        disp("Valor de zc1: " + mat2str(zc1));
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
    else
        numC1 = 1;
    end 

    %% CONDICIÓN DE MAGNITUD
    K = (abs(polyval(denC, sd)) * abs(polyval(den, sd))) / (abs(polyval(num, sd)) * abs(polyval(numC1, sd)) * ...
    abs(polyval(numC2, sd)));

    numC = K * conv(numC1, numC2);

    %% HALLANDO kp, Ti, Td
    switch tipo
        case 'P'
            kp = K;
            disp("kp: " + mat2str(kp));
        case 'I'
            ki = K;
            disp("ki: " + mat2str(ki));
        case 'PI'
            kp = K;
            Ti = 1/zc1;
            disp("Ti: " + mat2str(Ti) + "\tkp: " + mat2str(kp));
        case 'PD'
            Td = 1/zc1;
            kd = K;
            kp = K/Td;
            disp("Td: " + mat2str(Td) + "\tkd: " + mat2str(kd) + "\tkp: " + mat2str(kp));
        case 'PID'
            Td = 1/(zc1 + zc2);
            Ti = (zc1 + zc2)/(zc1*zc2);
            kd = K;
            kp = kd/Td;
            disp("Td: " + mat2str(Td) + "\tTi: " + mat2str(Ti) + "\tkd: " + mat2str(kd) + "\tkp: " + mat2str(kp));
        case 'ADELANTO'
            disp("Valor de alpha: " + mat2str(zc2/pc));
        case 'ATRASO'
            disp("Valor de alpha: " + mat2str(zc2/pc));
    end
end