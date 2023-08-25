clc;
clear;
close all;

M = 16; % Ordinul filtrului
wc = 0.4*pi; % Pulsatia de taiere

% Definim tipurile de ferestre
window_functions = {
    @boxcar, @triang, @blackman, ...
    @(M) chebwin(M, 60), @hamming, @hanning, ...
    @(M) kaiser(M, 4), @(M) tukeywin(M, 0.5), @(M) lanczos(M, 10)
};

window_names = {
    'Dreptunghiulara', 'Triunghiulara', 'Blackman', ...
    'Chebyshev', 'Hamming', 'Hanning', ...
    'Kaiser', 'Tukey', 'Lanczos'
};

% Proiectăm filtrele pentru fiecare fereastră și comparăm caracteristicile
figure;

for i = 1:length(window_functions)
    b = fir1(M-1, wc/pi, window_functions{i}(M));
    [h, w] = freqz(b, 1);
    
    subplot(3, 3, i);
    plot(w/pi, 20*log10(abs(h)));
    title(['Filtru ' window_names{i}]);
    xlabel('Frecvență Normalizată (\times \pi rad/sample)');
    ylabel('Magnitudine (dB)');
    xlim([0, 1]);
    ylim([-60, 5]); % Ajustăm limita inferioară pentru a vedea mai bine atenuările
end

sgtitle('Caracteristici de Frecvență ale Filtrelor FIR');

%  înțelegem că filtrele cu atenuare mare în banda de trecere vor avea 
% benzi de tranziție mai largi, în timp ce cele cu benzi de tranziție 
% înguste vor avea atenuări mai mici. Acest lucru poate fi observat 
% în graficele rezultate, unde filtrele cu ferestre care prezintă
% loburi principale înguste vor avea benzi de tranziție mai înguste,
% dar cu atenuări mai mici în banda de trecere, și invers.

% Alegem Chebisev pentru ca:
% Filtrul Chebyshev permite obținerea unei atenuări mai rapide și
% mai abrupte în banda de oprire decât alte ferestre. 
% Acest lucru este util atunci când este necesară o atenuare 
% semnificativă în afara benzii de trecere.

% prezintă perturbații în banda de trecere în schimbul
% caracteristicii sale de atenuare abruptă. 
% Aceste perturbații pot fi semnificative în anumite cazuri și 
% pot afecta performanța filtrului, în special în aplicații în
% care este importantă o bandă de trecere cu magnitudine constantă.

% Pentru a obține aceeași specificație a filtrului 
% (atenuare în banda de oprire, frecvență de tăiere, etc.), 
% ordinul unui filtru Chebyshev poate fi mai mic decât al 
% altor ferestre cu caracteristici similare.