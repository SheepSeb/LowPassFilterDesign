clc;
clear;
close all;

best_order = inf;
best_filter = [];
best_window = '';
best_params = [];
best_t = inf;
omeg_save = 0;

% Specificațiile filtrului
wp = pi/2; % frecvența de tăiere pentru banda de trecere
ws = pi;   % frecvența de tăiere pentru banda de stopare
delta_pr_max = 0.01; % abaterea maximă în banda de trecere
delta_sr_max = 0.01; % abaterea maximă în banda de stopare

% Cautare pentru acesti parametri
r = [10 20 30 40 50 60 70 80 90 95 100];
beta = [1 5 10 20 25 30 40 50 90 95 100];
alfa = [0 0.1 0.15 0.2 0.25 0.3 0.45 0.5 0.8 0.9 1];

window_functions = {
    @boxcar, @triang, @blackman, ...
    @(M) chebwin(M, 60), @hamming, @hanning, ...
    @(M) kaiser(M, 4), @(M) tukeywin(M, 0.5)
};

for i = 1:length(r)
    M = 3;
    r_ac = r(i);
    beta_ac = beta(i);
    alfa_ac = alfa(i);
    
    window_names = {
        'Dreptunghiulara', 'Triunghiulara', 'Blackman', ...
        ['Chebîşev (r=' num2str(r_ac) ')'], ...
        'Hamming', 'Hanning', ...
        ['Kaiser (\beta=' num2str(beta_ac) ')'], ...
        ['Tuckey (\alpha=' num2str(alfa_ac) ')'], ...
    };

    for j = 1:length(window_functions)
        M = 3;
        wc = sqrt(wp * ws);
        win_t = window_functions{j};
        [h, ~] = fir1(M-1, wc/pi, win_t(M));
        [h_found, omeg,M, wc, Delta_pr, Delta_sr] = calculate_filter_deviations_f4(h, wp, ws, delta_pr_max, delta_sr_max, win_t);
        
        Delta_t = Delta_sr + Delta_pr;

        fprintf('Filtru pentru %s cu parametri r=%d, beta=%d, alfa=%.2f:\n', window_names{j}, r_ac, beta_ac, alfa_ac);
        fprintf('Ordin: %d\n', M);
        fprintf('Abaterea in banda de trecere (∆p): %.4f\n', Delta_pr);
        fprintf('Abaterea in banda de stopare (∆s): %.4f\n', Delta_sr);
        fprintf('Abaterea in total: %.4f\n\n', Delta_t);

        if M < best_order
            best_order = M;
            best_filter = h_found;
            best_window = window_names{j};
            best_param = [r_ac, beta_ac, alfa_ac];
            best_t = Delta_t;
            omeg_save = omeg;
            if Delta_t < best_t
                best_t = Delta_t;
            end
        end
    end
end

fprintf('Cel mai bun filtru este cu:\n');
fprintf('Ordin: %d\n', best_order);
fprintf('Fereastra: %s\n', best_window);
fprintf('Abatere: %s\n', best_t);

% Proiectați și afișați cel mai bun filtru
figure;
[H, w] = freqz(best_filter, 1, 1024);
subplot(2, 1, 1);
plot(w/pi, abs(H));
title('Raspunsul in Frecventa al Celui Mai Bun Filtru');
xlabel('Frecventa Normalizata (\times \pi rad/sample)');
ylabel('Magnitudine');
xlim([0, 1.1]);
yline(1+Delta_pr, 'r--', '\Delta_p');
yline(1-Delta_pr, 'r--', '\Delta_p');
yline(Delta_sr, 'r--', '\Delta_s');
xline(wp/pi, '--r', '\omega_p');
xline(ws/pi, '--b', '\omega_s');
grid on;

subplot(2, 1, 2);
plot(w/pi, angle(H));
title('Faza Raspunsului in Frecventa al Celui Mai Bun Filtru');
xlabel('Frecventa Normalizata (\times \pi rad/sample)');
ylabel('Faza (rad)');
xlim([0, 1]);
grid on;

sgtitle(['Caracteristicile Celui Mai Bun Filtru']);
