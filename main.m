clc;
clear;

%% Datos de la planta 
n = input("ingresa el tamaño de columnas del vector num: ");
num = zeros(1, n);

for i = 1:n
    num(i) = input("Ingresa el valor: ");
    disp("Valor #" + i + " es: " + num(i));
end

n = input("ingresa el tamaño de columnas del vector den: ");
den = zeros(1, n);

for i = 1:n
    den(i) = input("Ingresa el valor: ");
    disp("Valor #" + i + " es: " + den(i));
end


%% ROOT LOCUS ORIGINAL Y RESPUESTA ANTE EL ESCALÓN
tfinal = input("ingresa el step: "); %NÚMERO LIMITE DE LA ENTRADA
graficar_step(num, den, tfinal);

%% Raices deseadas
tss = input("Ingresa el valor de tss: ");
chi = input("Ingresa el valor de chi: ");
[sd, sigma, wd] = raicesDeseadas(tss, chi);
disp("Valor de sd: " + mat2str(sd));
ess_actual = calcularEss(num, den);
disp("Valor del error en estado estable actual: " + mat2str(ess_actual));
conf = 1;

%% PROBANDO CONTROLADORES
while(conf == 1)
    tipo= input("Ingresa el tipo de control: ");
    zc2 = input("Ingresa el valor deseado de zc2: ");
    modo = input("Ingresa el modo del amortiguador, si se eligió (1: Parche, 0: Normal/No aplica): ");
    ess_deseado = input("Ingresa el valor del error en estado estable deseado: ")
    [numC, denC, kp, Ti, Td] = controlador(num, den, tipo, zc2, sd, sigma, wd, modo, ess_deseado);
    num2 = conv(num, numC);
    den2 = conv(den, denC);
    % Display the new transfer function
    disp("Nuevo sistema: Numerador = " + mat2str(num2) + ", Denominador = " + mat2str(den2));
    graficar_step(num2, den2, tfinal);
    conf = input("¿Desea continuar? (1: sí, 0: no): ");
end