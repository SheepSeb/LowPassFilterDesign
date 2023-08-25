% Faza 3-a
function [M, wc,Delta_pr, Delta_sr] = calculate_filter_deviations(h, wp, ws, delta_pr_max, delta_sr_max,win_t)
    M = length(h) - 1; % Initial order
    wc = sqrt(wp * ws); % Initial cutoff frequency
    
    while true
        
        h_filtered = create_filter(M, wc, win_t);
        
        [Delta_pr, Delta_sr] = calculate_deviations(h_filtered, wp, ws);
        
        if Delta_pr <= delta_pr_max && Delta_sr <= delta_sr_max
            [Delta_pr_new,Delta_sr_new] = calculate_filter_down(h_filtered,wp,ws,delta_pr_max,delta_sr_max,win_t);
            return; % Filter is valid
        else
            M = M + 1;
            wc = sqrt(wp * ws);
        end
        
        if M <= 1
            error('Niciun filtru valid, schimbati fereastra ,ordinul');
        end
    end
end

% Functie care creeaza un filtru
function h_filtered = create_filter(M, wc, window_t)
    h_filtered = fir1(M-1, wc/pi, window_t(M));
end

% Functie de calcul pt deviatie
function [Delta_pr, Delta_sr] = calculate_deviations(h, wp, ws)
    grid_freq_p = linspace(0, wp, 1000);
    H_p = freqz(h, 1, grid_freq_p);
    Delta_pr = max(abs(1 - abs(H_p)));
    
    grid_freq_s = linspace(ws, pi, 1000);
    H_s = freqz(h, 1, grid_freq_s);
    Delta_sr = max(abs(H_s));
end

% Calcul daca exista filtru cu ordin mai mic 
function [Delta_pr, Delta_sr] = calculate_filter_down(h, wp, ws, delta_pr_max, delta_sr_max, win_t)
    M = length(h) - 1; % Initial order
    wc = sqrt(wp * ws); % Initial cutoff frequency
    
    while true
        % Design the FIR filter using the specified window
        disp(M)
        
        h_filtered = fir1(M-1, wc/pi, win_t(M));
        
        % Calculate deviations
        [Delta_pr, Delta_sr] = calculate_deviations(h_filtered, wp, ws);
        
        % Check if the filter meets specifications
        if Delta_pr <= delta_pr_max && Delta_sr <= delta_sr_max
            return; % Filter is valid
        end
        
        % Decrease order M and recalculate cutoff frequency wc
        M = M - 1;
        wc = sqrt(wp * ws);
        
        if M <= 1
            disp('Niciun filtru mai mic');
            break;
        end
    end
end