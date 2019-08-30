% thesis on Emotion Detection from ECG signal
% this is the main part of the code where all parts , all routines are
% brought together

clear all
close all
clc


mit_data=0;   % mit_data=0 means we are dealing with the dataset given in AVEC 
                % on the other hand mit_data=1 indicates that we are
                % working on mit bih database
                
lower_file=9;    % here for AVEC dataset, lower_file and upper_file are respectively 1 and 27 
upper_file=9;      % on the other hand mit bih database has respectively 0 and 47

data_matrix=extract_data(lower_file,upper_file,mit_data);
if mit_data==1
    sampling_freq=360;  % mit bih data is sampled at this sampling frequency
else
    sampling_freq=1000;  % as the adjacent samples are 1mm apart in AVEC dataset
end

size(data_matrix)

fprintf('--- data extraction is complete ---\n');

% frequency_analysis(data_matrix,upper_file-lower_file+1,sampling_freq);

[qrs_peaks,p_wave_peaks,t_wave_peaks]=ecg_peaks(data_matrix,sampling_freq);



