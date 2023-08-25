clear;
clc;
close all;
% Specificațiile filtrului
wp = 0.3*pi;    % Frecvența de trecere
ws = 0.5*pi;    % Frecvența de stopare
delta_pr_max = 0.05; % Abaterea maximă în banda de trecere
delta_sr_max = 0.05; % Abaterea maximă în banda de stopare

% Alegerea ordinului inițial și ferestrei
M = 20; % Ordinul inițial al filtrului
wc = sqrt(wp * ws); % Frecvența de tăiere inițială
window_type = @(M) chebwin(M,60); % Tipul de fereastră

% Proiectarea filtrului
[h, ~] = fir1(M-1, wc/pi, window_type(M));

% Calcularea abaterilor
[M,wc,Delta_pr, Delta_sr] = calculate_filter_deviations(h, wp, ws, delta_pr_max, delta_sr_max, window_type);

% Afișarea rezultatelor
fprintf('Filtru proiectat cu M = %d, wc = %.4f*pi, %s fereastra:\n', M, wc/pi, func2str(window_type));
fprintf('Delta_pr = %.4f, Delta_sr = %.4f\n', Delta_pr, Delta_sr);

% Calcularea răspunsului în frecvență
[H, w] = freqz(h, 1, 1024);

% Afișarea răspunsului în frecvență
figure;
subplot(2, 1, 1);
plot(w/pi, abs(H));
title('Raspunsul in Frecventa al Filtrului Proiectat');
xlabel('Frecventa Normalizata (\times \pi rad/sample)');
ylabel('Magnitudine');
xlim([0, 1]);
yline(1+Delta_pr, 'r--', '\Delta_p');
yline(1-Delta_pr, 'r--', '\Delta_p');
yline(Delta_sr, 'r--', '\Delta_s');
grid on;

subplot(2, 1, 2);
plot(w/pi, angle(H));
title('Faza Raspunsului in Frecventa al Filtrului Proiectat');
xlabel('Frecventa Normalizata (\times \pi rad/sample)');
ylabel('Faza (rad)');
xlim([0, 1]);
grid on;

sgtitle(['Caracteristicile filtrului proiectat cu M = ' num2str(M) ', wc = ' num2str(wc/pi) '\pi, ' func2str(window_type) ' fereastra']);


