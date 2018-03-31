function [ multiFrequency ] = phoneDigitConverter( phoneDigit )
    % PHONEDIGITCONVERTER
    %   This function converts a given phone digit to a dual tone
    %   multi-frequency.
    %   
    %   INPUT:
    %       - phoneDigit: corresponds to a digit that belongs to the set 
    %                     {0,1,2,3,4,5,6,7,8,9,0,*,#}. It must be a string.
    %   
    %   OUTPUT:
    %       - multiFrequency: this will correspond to a structure that has
    %                     the frequencies of the dual tone. The frequencies
    %                     are given in Hz.
    %
    
    % Initializes output
    multiFrequency = struct('fa',nan,'fb',nan);
    
    % Obtain first frequency component
    switch phoneDigit
        case {'1','2','3'} 
            multiFrequency.fa = 697;
        case {'4','5','6'} 
            multiFrequency.fa = 770;
        case {'7','8','9'} 
            multiFrequency.fa = 852;
        case {'0','*','#'} 
            multiFrequency.fa = 941;
    end
    
    % Obtain second frequency component
    switch phoneDigit
        case {'1','4','7','*'} 
            multiFrequency.fb = 1209;
        case {'2','5','8','0'} 
            multiFrequency.fb = 1336;
        case {'3','6','9','#'} 
            multiFrequency.fb = 1477;
    end
end
