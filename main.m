clc;
clear;

%% DATOS DE LA PLANTA
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

%% RAÍCES DESEADAS
tss = input("Ingresa el valor de tss: ");
chi = input("Ingresa el valor de chi: ");
[sd, sigma, wd] = raicesDeseadas(tss, chi);

conf = 1;

%% PROBANDO CONTROLADORES
while(conf == 1)
    tipo= input("Ingresa el tipo de control: ");
    zc2 = input("Ingresa el valor deseado de zc2: ");
    [numC, denC, kp, Ti, ~] = controlador(num, den, tipo, zc2, sd, sigma, wd);
    num2 = conv(num, numC);
    den2 = conv(den, denC);
    % Display the new transfer function
    disp("Nuevo sistema: Numerador = " + mat2str(num2) + ", Denominador = " + mat2str(den2));
    graficar_step(num2, den2, tfinal);
    conf = input("¿Desea continuar? (1: sí, 0: no): ");
end