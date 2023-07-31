function [result] = FM_transmission_function(f_sample, freq_dev, f_center, baseband_sample, audio_message)
    %% FM transmitter for ADALM PLUTO radio via MATLAB Interface
    %---------------------------------------------------------------------%
    % Batya Vishnepolsky--6/2023                                          %
    %                                                                     %
    % This function takes in the parameters for FM modulation and         %
    % performs FM transmission of an input audio file.                    %
    %                                                                     %
    % This function is compatable with an ADALM Pluto Radio.              %
    %                                                                     %
    % The user of the function must have installed DSP, Pluto support,    % 
    % and communications support toolboxes from MathWorks.                %
    %---------------------------------------------------------------------%

    %% Variables and their explanations
    % f_sample = 1.2e6;                     % frequency sample rate of the signal
    % freq_dev = 75e3;                      % frequency deviation
    % f_center = 400e6;                     % Center frequency of baseband
    % baseband_sample = 1.0e6;              % Baseband sample rate
    
    %% Audio Signal
    
    % audio_message = 'blink182.mp3';       %include file path unless music is in the same folder as this script
    
    audio_signal = dsp.AudioFileReader('Filename',audio_message, ...
        'SamplesPerFrame', 4410); % Reads the data file and outputs it as a double
    
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
    
    % transmit frame by frame
      while ~isDone(audio_signal)
        input = audio_signal();
        yFM = fm_mod(input); % FM modulate
        txpluto(yFM);
      end   
    
    result = 'Transmission Over'
end