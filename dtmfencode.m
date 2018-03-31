function [phoneSignal] = dtmfencode(phoneKeys, toneDuration, pauseDuration, amplitude, noiseLevel, samplingFrequency)
    % DTMFENCODE
    %
    %   [phoneSignal] = dtmfencode(phoneKeys, toneDuration, pauseDuration, amplitude, noiseLevel, samplingFrequency)
    %
    %   This function yields the DTMF signal that results from encoding
    %   a given sequence of phone keys.
    %   
    %   INPUT:
    %       - phoneKeys:   A string of characters belonging to the set
    %                      {0,1,2,3,4,5,6,7,8,9,*,#}, representing a
    %                      sequence of phone keys.
    %       - toneDuration (optional): The duration of each key press,
    %                      in miliseconds. Default value: 40.
    %       - pauseDuration (optional): The duration of the pauses between
    %                      key presses, in miliseconds. Default value: 40.
    %       - amplitude (optional): the amplitude of each of the sinusoids,
    %                      within tone segments. Default value: 1.
    %       - noiseLevel (optional): The standard deviation of the Gaussian
    %                      noise that is added to the DTMF signal, measured
    %                      relative to the sinusoid amplitude; the standard
    %                      deviation of the noise is given by
    %                      noiseLevel * amplitude.
    %                      Default value: 0.
    %       - samplingFrequency (optional): The sampling frequency of the
    %                      DTMF signal that is generated, in Hz.
    %                      Default value: 8000.
    %   
    %   OUTPUT:
    %       - phoneSignal: the DTMF signal that results from the given key
    %                      sequence.
    %
    %   NOTE: You can omit any number of optional arguments in the end of the
    %       function call, to use their default values, but you cannot omit
    %       intermediate arguments. For example, you can use the call
    %           dtmfencode(s,100),
    %       which is equivalent to
    %           dtmfencode(s,100,40,1,0,8000),
    %       but you cannot use calls like
    %           dtmfencode(s,,100)
    %       or
    %           dtmfencode(s,[],100).
    
    
    % Check that we have a valid number of arguments.
    narginchk(1,6);
    
    % Initialize the optional parameters to the default values, if necessary
    if nargin <= 5
        samplingFrequency = 8000;
    end
    if nargin <= 4
        noiseLevel = 0;
    end
    if nargin <= 3
        amplitude = 1;
    end
    if nargin <= 2
        pauseDuration = 40;
    end
    if nargin == 1
        toneDuration  = 40;
    end
        
    % Generate the sample times within a tone interval.
    % Remember that the tone interval is in millisecods
    times = 0 : 1/samplingFrequency : toneDuration/1000;
    
    % Generate the pause block between tones.
    % Remember that the pause interval is in milliseconds
    blockLength = round((pauseDuration / 1000) * samplingFrequency);
    pauseBlock  = zeros(1,blockLength);
    
    % Convert the phone number to a signal
    phoneSignal = [];
    for phoneDigit = phoneKeys
        % Obtain the pair of frequencies for the phone key
        multiFrequency = phoneDigitConverter(phoneDigit);
        
        % Generate the tones
        toneBlock   = amplitude * (sin(2 * pi * multiFrequency.fa * times) ...
                    + sin(2 * pi * multiFrequency.fb * times));
                
        % Append the tones and a pause to the signal
        phoneSignal = [phoneSignal, toneBlock, pauseBlock]; %#ok<AGROW>
    end
    
    % Add the noise
    phoneSignal = phoneSignal + noiseLevel * amplitude * randn(size(phoneSignal));
    
end
