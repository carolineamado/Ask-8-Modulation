clear all

close all

%Grupo: Bruna Sigaia, Caroline Amado, Felipe Augusto de Menezes, Nathalia Chagas.
%1) Gerar uma seq��ncia de bits aleat�rios bk com p0 = 0.5 e um determinado

%p0 probabilidade
p0=0.5;

%Nb n�mero de bits gerados
Nb= 12000;

%Sequ�ncia de bits aleat�rios
bk = ones(1,Nb);

Y = rand(size(bk));

I = find(Y > p0);

bk(I) = 0;

%2) Agrupar em blocos de  log2(M) bits e criar a partir dos blocos uma
%seq��ncia de s�mbolos M-�rios An.

%onde 8 � valor de simbolos
bloco=log2(8);
%onde 8 � valor de simbolosOu seja, os valores de bk dever�o ser organizados de 3 em 3

%Agrupando em blocos de log2(M)
n = 1:3:Nb;  
bkm((n+2)/3) = bk(n)*100 + bk(n+1)*10 + bk(n+2);   
          
 ruido = 0:0.5:64;

for c = 1:length(ruido)
    
  [BER, SNR] = ask8(bk, bkm, ruido(c));
   
  biterror(c) = BER;
   
  sinalruido(c) = SNR;
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Graficos

%Plot o grafico discreto de bk
%figure(7)
%stem(1:length(bk),bk)
%title('Grafico de bks');

%Plot do BERX SNR
figure(8)
plot(sinalruido,biterror);grid minor
title('BER X SNR');
xlabel('SNR'); ylabel('BER');