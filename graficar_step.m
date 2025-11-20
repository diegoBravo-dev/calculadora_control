function graficar_step(num, den, tfinal)

    sys = tf(num, den); % CREAMOS FUNCIÓN DE TRANSFERENCIA
    figure
    subplot(1, 2, 1); %GRAFICAMOS
    rlocus(sys); %HACEMOS EL ROOT LOCUS
    H=1;
    SLC = feedback(sys, H); %CREAMOS UN SISTEMA EN LAZO CERRADO
    subplot(1, 2, 2);
    step(SLC, tfinal); %LE METEMOS UN STEP COMO ENTRADA AL SISTEMA
end