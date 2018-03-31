%% Segundo laboratorio de PDS
%
% Grupo 14
% Andre Ferreira 81715
% Jose Miragaia 81567

%% Teste para observar valores experimentais de frequencias de sinusoides

phoneKeys = ['1', '5', '9', '#'];
toneDuration = 40;
pauseDuration = 40;
amplitude = 1;
noiseLevel = 0;
samplingFrequency = 8000;

phoneSignal = dtmfencode(phoneKeys, toneDuration, pauseDuration, amplitude, noiseLevel, samplingFrequency);
[S,F,T] = spectrogram(phoneSignal);
surf(T, F*1000, abs(S));
xlabel('t(ms)');
ylabel('f(Hz)');

%%
% From figure SinFreqTest:
%
% F11 = 546.1
% F12 = 607.5
% F13 = 668.8
% F14 = 736.3
%
% F21 = 951.1
% F22 = 1049
% F23 = 1160