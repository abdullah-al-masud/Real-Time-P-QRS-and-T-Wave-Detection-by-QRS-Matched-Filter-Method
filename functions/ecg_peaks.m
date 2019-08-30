function [qrs_peaks,p_wave_peaks,t_wave_peaks]=ecg_peaks(data_matrix,sampling_freq)

[data_length , total_ecg]=size(data_matrix);

qrs_peaks=zeros(data_length,total_ecg);
p_wave_peaks=qrs_peaks;
t_wave_peaks=qrs_peaks;


%% this portion is for QRS detection 
filtered_ecg=pre_processing_filter_3(data_matrix,total_ecg);
[qrs_peaks, total_peaks]=qrs_peak_detection(filtered_ecg,sampling_freq);
total_peaks

% QRS alignment
aligned_qrs=aligning_qrs(data_matrix,qrs_peaks,sampling_freq);
% 
% % this part of code is intented to see how well ecg QRS peaks are detected
% 
% for i=1:total_ecg
%     
%     figure
%     plot(data_matrix(:,i));
%     hold on
%     aligned_qrs_pos=find(aligned_qrs(:,i)==1);
%     stem(aligned_qrs_pos,2*data_matrix(aligned_qrs_pos,i),'.k');
%     hold off
% end
% 
% 
%% this part is for P wave detection And T wave detection

[p_wave_peaks , t_wave_peaks]=p_and_t_wave_detection(data_matrix, filtered_ecg, aligned_qrs, total_peaks, sampling_freq);



%%

end
