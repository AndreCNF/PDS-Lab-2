% Find the true 3D peaks / local maxima in a dtmf
function true_peaks = dtmfdecode(S, F, T)
    locs_f = zeros(2, length(T));
    locs_t = zeros(2, length(F));
    
    % Maximum of 10 tones
    true_peaks = zeros(3, 10);

    % Find local maxima in time domain
    for i = 1:length(T)
        % Find local maxima (peaks) sorted by tallest to shortest
        [PKS, LOCS] = findpeaks(abs(S(:,i)), 'SortStr', 'descend');
        
        % Only the 2 highest peaks matter (only 2 sinusoides per tone)
        locs_f(:, i) = LOCS(1:2, 1);
    end
    
    % Find local maxima in frequency domain
    for i = 1:length(F)
        % Find local maxima (peaks) sorted by tallest to shortest
        [PKS, LOCS] = findpeaks(abs(S(i,:)), 'SortStr', 'descend');
        
        % Only the 2 highest peaks matter (only 2 sinusoides per tone)
        locs_t(:, i) = LOCS(1:2, 1);
    end
    
    n = 1;
    
    % Match maxima from time and frequency domains to get the true peaks
    for i = 1:length(T)
        for j = 1:length(F)
            for k = 1:2
                for l = 1:2
                    if locs_f(k, i) == F(j) && locs_t(l, j) == T(i)
                        true_peaks(:, n) = [S(F(j), T(i)), F(j), T(i)];
                        n = n +1;
                    end
                end
            end
        end
    end
end