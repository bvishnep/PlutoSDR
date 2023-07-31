%% FM transmitter for ADALM PLUTO radio via MATLAB Interface

%% Variables

% FM modulation variables
f_sample = 1.2e6;           % frequency sample rate of the signal
freq_dev = 75e3;            % frequency deviation
input_sample = 48e3;        % Sample rate of the input signal
f_center = 400e6;           % Center frequency of baseband
baseband_sample = 1.0e6;      % Baseband sample rate

% location of audio file you want to transmit
audio_message = 'blink182.mp3';


%% Multimedia block

audio_signal = dsp.AudioFileReader('Filename',audio_message, 'SamplesPerFrame',4410); % Reads the data file and outputs it as a double

%% Configure the PLUTO radio

txpluto = sdrtx('Pluto', 'CenterFrequency', f_center, ...
    'BasebandSampleRate', baseband_sample, 'Gain', -10);
info(txpluto)                      % Display SDR information


%% FM modulation and transmition

% set up all the object params
fm_mod = comm.FMBroadcastModulator( ...
    'AudioSampleRate', audio_signal.SampleRate, ...
    'FilterTimeConstant', 75e-06, ...
    'SampleRate', f_sample, ...
    'FrequencyDeviation', freq_dev, ...
    'Stereo', true); 

  while ~isDone(audio_signal)
    input = audio_signal();
    yFM = fm_mod(input); % FM modulate
    txpluto(yFM);
  end   




 



