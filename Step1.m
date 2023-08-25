clc;
clear;
close all;

M = 16;

r = [80 90 95 100];
beta = [0 1 5 10];
L = [0 1 2 3];
alfa = [0 0.25 0.5 1];


for i = 1:length(r)
    r_ac = r(i);
    beta_ac = beta(i);
    L_ac = L(i);
    alfa_ac = alfa(i);

    w_box=boxcar(M) ; % Fereastra dreptunghiulara
    w_tri=triang(M) ; % Fereastra triunghiulara
    w_black=blackman(M) ; % Fereastra Blackman
    w_cheb=chebwin(M,r_ac) ; % Fereastra Cebîşev
    w_ham=hamming(M) ; % Fereastra Hamming
    w_han=hanning(M) ; % Fereastra Hanning
    w_ka=kaiser(M,beta_ac) ; % Fereastra Kaiser
    w_tu=tukeywin(M,alfa_ac) ; % Fereastra Tuckey
    w_lan=lanczos(M,L_ac); % Fereastra Lanczos

    space = 1:M;
    
    window_names = {
        'Dreptunghiulara', 'Triunghiulara', 'Blackman', ...
        ['Chebîşev (r=' num2str(r_ac) ')'], ...
        'Hamming', 'Hanning', ...
        ['Kaiser (\beta=' num2str(beta_ac) ')'], ...
        ['Tuckey (\alpha=' num2str(alfa_ac) ')'], ...
        ['Lanczos (L=' num2str(L_ac) ')']
    };
    
    window_functions = {
        w_box, w_tri, w_black, w_cheb, w_ham, w_han, w_ka, w_tu, w_lan
    };
    figure;
    for j = 1:length(window_names)
        subplot(3, 3, j);
        stem(space, window_functions{j});
        title(window_names{j});
        xlim([0 M+1]);
        ylim([min(window_functions{j}) - 0.1, max(window_functions{j}) + 0.1]);
    end
    sgtitle('Window Functions');
end