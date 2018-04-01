% Find the true 3D peaks / local maxima in a dtmf
function true_peaks = dtmfdecode(S, F, T)
%     locs_f = zeros(2, length(T));
%     locs_t = zeros(2, length(F));
%     
%     % Maximum of 10 tones
%     true_peaks = zeros(3, 10);
% 
%     % Find local maxima in time domain
%     for i = 1:length(T)
%         % Find local maxima (peaks) sorted by tallest to shortest
%         [PKS, LOCS] = findpeaks(abs(S(:,i)), 'SortStr', 'descend');
%         
%         if length(LOCS) < 2
%             locs_f(:, i) = [-1; -1];
%             continue;
%         end
%         
%         % Only the 2 highest peaks matter (only 2 sinusoides per tone)
%         locs_f(:, i) = LOCS(1:2, 1);
%     end
%     
%     % Find local maxima in frequency domain
%     for i = 1:length(F)
%         % Find local maxima (peaks) sorted by tallest to shortest
%         [PKS, LOCS] = findpeaks(abs(S(i,:))', 'SortStr', 'descend');
%         
%         if length(LOCS) < 2
%             locs_t(:, i) = [-1; -1];
%             continue;
%         end
%         
%         % Only the 2 highest peaks matter (only 2 sinusoides per tone)
%         locs_t(:, i) = LOCS(1:2, 1);
%     end
%     
%     n = 1;
%     
%     % Match maxima from time and frequency domains to get the true peaks
%     for i = 1:length(T)
%         for j = 1:length(F)
%             for k = 1:2
%                 for l = 1:2
%                     % if locs_f(k, i) == F(j) && locs_t(j, l) == T(i)
%                     if locs_f(k, i) == j && locs_t(j, l) == i
%                         true_peaks(:, n) = [S(F(j), T(i)), F(j), T(i)];
%                         n = n +1;
%                     end
%                 end
%             end
%         end
%     end


%    [row,col] = find(imregionalmax(abs(S)));
%    hold on
%    plot3(T(col),F(row)*1000,abs(S(row, col)),'r*','MarkerSize',24)


    true_peaks = zeros(length(F), length(T));
    
    % Check for peaks that are reagional maxima
    for i = 1:length(F)
        for j = 1:length(T)
            % Height treshold
            if abs(S(i, j)) < 80
                continue;
            end
            
            try
                if abs(S(i-1, j-1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i-1, j)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i-1, j+1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i+1, j-1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i+1, j)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i+1, j+1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i, j-1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            try
                if abs(S(i, j+1)) >= abs(S(i, j))
                    continue;
                end
            end
            
            true_peaks(i, j) = 1;
        end
    end
end