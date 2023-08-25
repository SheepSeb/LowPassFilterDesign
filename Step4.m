clc;
clear;
close all;

wc = 0.4*pi; % Pulsatia de taiere

M_values = [16, 24, 32];
figure;

for i = 1:length(M_values)
    M = M_values(i);
    b = fir1(M-1, wc/pi, chebwin(M, 60));
    [h, w] = freqz(b, 1);
    
    subplot(3, 1, i);
    plot(w/pi, 20*log10(abs(h)));
    title(['Filtru Chebyshev cu M = ' num2str(M)]);
    xlabel('Frecvență Normalizată (\times \pi rad/sample)');
    ylabel('Magnitudine (dB)');
    xlim([0, 1]);
    ylim([-60, 5]);
end

sgtitle('Evoluția Caracteristicilor de Frecvență ale Filtrului Chebyshev');

% Cu creșterea ordinului (M), lobul principal devine mai îngust.
% Acest lucru înseamnă că banda de trecere devine mai îngustă 
% și se obține o atenuare mai abruptă în banda de oprire.

% Pe măsură ce M crește, perturbațiile în banda de trecere 
% devin mai accentuate. De obicei, perturbațiile sunt mai
% pronunțate în jurul frecvenței de tăiere.

% De asemenea, pe măsură ce M crește, timpul de tranziție 
% se reduce, deoarece lobul principal devine mai îngust.
% Acest lucru poate fi benefic în unele aplicații care necesită 
% o tranziție rapidă între banda de trecere și banda de oprire
