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

    w_box=boxcar(128) ; % Fereastra dreptunghiulara
    w_tri=triang(M) ; % Fereastra triunghiulara
    w_black=blackman(M) ; % Fereastra Blackman
    w_cheb=chebwin(M,r_ac) ; % Fereastra Cebîşev
    w_ham=hamming(M) ; % Fereastra Hamming
    w_han=hanning(M) ; % Fereastra Hanning
    w_ka=kaiser(M,beta_ac) ; % Fereastra Kaiser
    w_tu=tukeywin(M,alfa_ac) ; % Fereastra Tuckey
    w_lan=lanczos(M,L_ac); % Fereastra Lanczos
        
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
        [h, w] = freqz(window_functions{j});
        plot(w/pi, mag2db(abs(h)));
        title([window_names{j} ' Window Frequency Response']);
        xlabel('Normalized Frequency (\times \pi rad/sample)');
        ylabel('Magnitude');
    end
    
    sgtitle('Frequency Response of Window Functions');
end

% Faza 1c
% Când analizăm răspunsurile în frecvență ale diverselor ferestre utilizate
% în prelucrarea semnalelor, observăm un fenomen interesant: 
% relația inversă între lățimea lobului principal și înălțimea
% lobilor secundari. Această observație se traduce printr-un
% set de caracteristici distinctive care definesc modul în
% care o fereastră influențează semnalul în spectrul său de frecvență.
% 
% În general, ferestrele care prezintă un lob principal îngust,
% adică un vârf îngust și bine definit în spectrul de frecvență, 
% sunt însoțite de lobi secundari înalți. Aceasta înseamnă 
% că energia semnalului este concentrată într-o plajă restrânsă 
% de frecvențe, ceea ce poate fi util în cazurile în care 
% este important să se evidențieze anumite componente frecvențiale 
% sau să se reducă influența componentelor în afara acestor limite.
% 
% Pe de altă parte, ferestrele cu un lob principal lat, care
% prezintă o structură mai extinsă în spectrul de frecvență,
% adesea sunt însoțite de lobi secundari scunzi. Acest lucru indică 
% faptul că energia semnalului se răspândește într-o plajă mai 
% largă de frecvențe, ceea ce poate fi util pentru a menține informația
% semnalului pe întreaga gamă de frecvențe sau pentru a minimiza
% distorsiunile în zonele spectrale învecinate.
% 
% Aceste proprietăți în frecvență au implicații semnificative
% în domeniul prelucrării semnalelor. De exemplu,
% atunci când se dorește o rezoluție fină în analiza 
% unor componente specifice ale semnalului, ferestrele cu 
% lățimea lobului principal redus pot fi preferate pentru a 
% izola aceste componente. În schimb, când se lucrează cu semnale 
% complexe, care cuprind mai multe componente cu frecvențe variate, 
% ferestrele cu lățimea lobului principal mai mare pot contribui 
% la menținerea contextului global al semnalului.
% 
% În concluzie, în alegerea ferestrei potrivite pentru o 
% anumită aplicație, trebuie să se țină cont de această
% relație inversă între lățimea lobului principal și 
% înălțimea lobilor secundari. Această înțelegere ne
% ajută să ajustăm caracteristicile ferestrei pentru a
% obține rezultate optime în funcție de contextul specific al prelucrării semnalelor.