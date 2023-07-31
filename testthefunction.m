% Variables and their explanations
f_sample = 1.2e6;                     % frequency sample rate of the signal
freq_dev = 75e3;                      % frequency deviation
f_center = 400e6;                     % Center frequency of baseband
baseband_sample = 1.0e6;              % Baseband sample rate

% Audio Signal

audio_message = 'blink182.mp3';

FM_transmission_function(f_sample, freq_dev, f_center, baseband_sample, audio_message)
