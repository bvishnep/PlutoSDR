
%% This file transmits an AM modulated signal using an ADALM PLUTO SDR
%% Batya Vishnepolsky, 08/02/2023

% Convert the .mp3 file into MATLAB readable format
[audio, Fs] = audioread('Annihilate.mp3'); % y is the audio data, and Fs is the sampling rate in hz

% if unable to shift the sampling frequency to a listenable sound, use the following parameters to
% change the song before transmission

	% audio = shiftPitch(audio,-5);
	%audio = stretchAudio(audio, (6/8.6));

%% Setting up an audio sound
audio = audio(:,1);


%% Setting up a sine wave (requires DSP toolbox)
length_ = length(audio); % match the size of the audio to the generated sine wave 
fs = 65105;
sw = dsp.SineWave;
sw.Amplitude = .5;
sw.Frequency = 1;
sw.ComplexOutput = false;
sw.SampleRate = fs;
sw.SamplesPerFrame = length(audio); % to meet waveform size requirements
tx_waveform = sw();



%% choose the type of transmission
% output = (tx_waveform.*(audio+1)); % AM TC DSB
output = (tx_waveform.*(audio)); % AM SC DSB
% mix a sine wave to shift the frequency from 0 to the new frequncy

%% Setting up the transmitter
tx = sdrtx('Pluto');

tx.CenterFrequency = 500e6;
tx.BasebandSampleRate = fs;
tx.Gain = -10;

%% using transmit repeat
transmitRepeat(tx, output);






