%Grupo: Bruna Sigaia, Caroline Amado, Felipe Augusto de Menezes, Nathalia Chagas.


function [BER, SNR] = ask8 (bk,bkm,ruido)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parte do Programa Alterável

%Sinal da portadora
w = 0.1*pi;

%Fase da portadora
theta = 0;

%Numero de amostras do sinal
N = 100;

%Sinal
S = cos(w*(0:N-1)+theta);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geração do vetor referência, caso o filtro casado apresente ganho e para
%ocorrerem as exatas associações

%Vetor com as determinadas amplitudes usadas nesta modulação ask-8
amp = [-3.5*S, -2.5*S, -1.5*S, -0.5*S, 0.5*S, 1.5*S, 2.5*S, 3.5*S];

P = fliplr(S);

%Sm corresponde ao vetor referencia
Sm = zeros(size(amp));
Nb = length(amp)/length(P);
Aref = zeros(1,Nb);
Na = length(P);
Ep = P*P';
hc = P/sqrt(Ep);

for n=1:Nb
	
	Z = conv(amp(Na*(n-1)+1:Na*n), hc);
	%Os valores para se usarem na decicao
    Aref(n) = Z(Na);
    %Saida do filtro casado para formar a onda
	Sm(Na*(n-1)+1:Na*n) = Z(1:Na);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Tabela de associação dos valores

%simbolos em binário
simbolo = [ 000, 1, 10, 11, 100, 101, 110, 111 ];

%Correspondencia dos simbolos de acordo com as amplitudes do sinal cosseno.
amplitude = [-3.5, -2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.5];

%3) Gerar o sinal ASK X(t) correspondente à seqüência

%localizacao do simbolo de bkm correspondente em amplitude

for g=1:length(bkm)
    
    for s=1:8
        
        if bkm(g) == simbolo(s)
            
                         
            xtaux(g)= amplitude(s);
                          
                       
        end
    
    end
    
end

%Valores de xt com amplitudes certas e uma variacao cossenoidal
for g = 1:length(xtaux)
    
    result = xtaux(g)*S;
    
    cont = 1;
    for k = (((g-1)*N)+1):g*N;
        
        xt(k) = result(cont);
        cont = cont + 1;
    end
    
end
    
%4) Contaminar o sinal X(t) com ruído aditivo gaussiano. No caso um ruído de potência 10 

Y = xt + ruido*randn(size(xt));

%5) Implementar um receptor com filtro casado e decisor MAP, obtendo a
%seqüência de simbolos decodificados ^A(n).

P = fliplr(S);

Yf = zeros(size(Y));
Nb = length(Y)/length(P);
Ar = zeros(1,Nb);
Na = length(P);
Ep = P*P';
hc = P/sqrt(Ep);

for n=1:Nb
	
	Z = conv(Y(Na*(n-1)+1:Na*n), hc);
	Ar(n) = Z(Na);
	Yf(Na*(n-1)+1:Na*n) = Z(1:Na);
end

%Decisor MAP - Implementação de Escolhe Hm desde que |y-sm|² seja minimo
for d=1:length(Ar)
       
       % Y-Sm
       for h = 1:8
           
           decide(h) = Ar(d)- Aref(h);
       
       end       
       %|Y-Sm|
       decide = abs(decide);
       
       %|Y-Sm|²
       decide = decide.^2;                  
         
       %Comparações para escolher o menor valor
       menor = decide(1);
       
       for a = 2:8
           
           if menor > decide(a)
               
               menor = decide(a);
               
           end
           
       end
               
       %decidindo
       for b = 1:8
           
           if menor == decide(b)
               
               decidido(d) = b;
               
           end
           
       end  
end

%Sinal Ân recuperado do decisor
for t = 1:length(decidido)
    
    %An recuperado
    An(t) = amplitude(decidido(t));

end

%Sinal An recuperado ou Ân
for g = 1:length(An)
    
    valores = An(g)*S;
    
    cont = 1;
    for k = (((g-1)*N)+1):g*N
        
        Anrec(k) = valores(cont);
        cont = cont + 1;
    end   
end

%6) Converter de ^An para ^bk, a seqüência de bits decodificados.
for t=1:length(An)    
    % bk recuperado depois de passar no decisor, ou ^bk
    bkaux(t) = simbolo(decidido(t));
    
end

for g = 1:length(bkaux)
    
    b1 = round(bkaux(g)/100);
    b2 = round((bkaux(g) - b1*100)/10);
    b3 = round(bkaux(g) - b2*10 - b1*100);
    
    bkrec((g-1)*3 +1)= b1;
    bkrec((g-1)*3 +2)= b2;
    bkrec((g-1)*3 +3)= b3;
    
end        
%7) Medir a taxa de erro de bit (BER - Bit Error Rate) para diversos
%valores de relação sinal ruído.

BER = sum(abs(bk-bkrec))/length(bk);
% Calculo do SNR
Potsinal = xt*xt';
Potruido = Y*Y';

SNR = Potsinal/Potruido;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Graficos

%Plot do vetor referencia
%figure(1)
%plot(Sm,'-b');grid minor
%title('Vetor referência do Decisor');
%xlabel(''); ylabel('');

%Plot de xt
%figure(2)
%plot(xt,'-b');grid minor
%title('Sinal Ask X(t)');

%Plot do grafico com o ruído
%figure(3)
%plot(Y,'-b');grid minor
%title('Sinal Ask X(t) com ruído');

%Plot do grafico com o ruído
%figure(4)
%plot(Yf,'-b');grid minor
%title('Saida do Filtro Casado')

%Plot de An depois de passar no decisor
%figure(5)
%plot(Anrec,'-b');grid minor
%title('Ân - An recuperado');

%plot de bk recuperado 
%figure(6)
%plot(bkaux,'-b');grid minor
%title('Ân');

end
