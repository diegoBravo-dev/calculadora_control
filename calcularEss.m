function ess = calcularEss(num, den)
    Kp = num(end) / den(end);
    ess = 1 / (1 + Kp);
end