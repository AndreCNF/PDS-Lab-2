% Find the true 3D peaks / local maxima in a dtmf
function keys_str = dtmfdecode(S, F, T)
    
    % Frequency threshold
    freq_thr = 30;
    
    % Noise threshold
    noise_thr = 200;
    
    F11 = 546.1;
    F12 = 607.5;
    F13 = 668.8;
    F14 = 736.3;
    F21 = 951.1;
    F22 = 1049;
    F23 = 1160;

    % Variable that will store the peaks of the spectrogram
    true_peaks = zeros(length(F), length(T));
    
    % String with the detected keys sequence
    keys_str = strings;
    
    % Check for peaks that are reagional maxima
    for i = 1:length(F)
        for j = 1:length(T)
            % Height treshold
            if abs(S(i, j)) < 30
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
    
    % Retrieve peak indexes in frequency (row) and time (col)
    [row,col] = find(true_peaks);
    
    % Search for noise / false peaks
    i = 1;
    while i <= (length(row)-1)
        % Remove single peaks
        if col(i) ~= col(i+1)
            if i == 1
                true_peaks(i, j) = 0;
                col(i) = [];
                row(i) = [];
                continue;
            elseif col(i) == col(i-1)
                i = i + 1;
                continue;
            else
                true_peaks(i, j) = 0;
                col(i) = [];
                row(i) = [];
                continue;
            end
        end
        
        % Remove false peaks (near true peaks)
        if abs(F(row(i)) - F(row(i+1)))*1000 < noise_thr && col(i) == col(i+1)
            if abs(S(row(i), col(j))) < abs(S(row(i+1), col(j+1)))
                true_peaks(i, j) = 0;
                col(i) = [];
                row(i) = [];
                continue;
            else
                true_peaks(i+1, j+1) = 0;
                col(i+1) = [];
                row(i+1) = [];
                continue;
            end
        end
        
        i = i + 1;
    end
    
    % Detect keys based on the peaks' frequencies
    for i = 1:2:length(row)
       if abs(F(row(i))*1000 - F11) < freq_thr
           if abs(F(row(i+1))*1000 - F21) < freq_thr
               keys_str = strcat(keys_str, '1');
           
           elseif abs(F(row(i+1))*1000 - F22) < freq_thr
               keys_str = strcat(keys_str, '2');
                
           elseif abs(F(row(i+1))*1000 - F23) < freq_thr
               keys_str = strcat(keys_str, '3');
           end
           
       elseif abs(F(row(i))*1000 - F12) < freq_thr
           if abs(F(row(i+1))*1000 - F21) < freq_thr
               keys_str = strcat(keys_str, '4');
           
           elseif abs(F(row(i+1))*1000 - F22) < freq_thr
               keys_str = strcat(keys_str, '5');
                
           elseif abs(F(row(i+1))*1000 - F23) < freq_thr
               keys_str = strcat(keys_str, '6');
           end
           
       elseif abs(F(row(i))*1000 - F13) < freq_thr
           if abs(F(row(i+1))*1000 - F21) < freq_thr
               keys_str = strcat(keys_str, '7');
           
           elseif abs(F(row(i+1))*1000 - F22) < freq_thr
               keys_str = strcat(keys_str, '8');
                
           elseif abs(F(row(i+1))*1000 - F23) < freq_thr
               keys_str = strcat(keys_str, '9');
           end
           
       elseif abs(F(row(i))*1000 - F14) < freq_thr
           if abs(F(row(i+1))*1000 - F21) < freq_thr
               keys_str = strcat(keys_str, '*');
           
           elseif abs(F(row(i+1))*1000 - F22) < freq_thr
               keys_str = strcat(keys_str, '0');
                
           elseif abs(F(row(i+1))*1000 - F23) < freq_thr
               keys_str = strcat(keys_str, '#');
           end
           
       end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure;
    surf(T, F*1000, abs(S));
    hold on 
    
    for i = 1:length(row)
         plot3(T(col(i)),F(row(i))*1000,abs(S(row(i), col(i))),'r*','MarkerSize',24)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end