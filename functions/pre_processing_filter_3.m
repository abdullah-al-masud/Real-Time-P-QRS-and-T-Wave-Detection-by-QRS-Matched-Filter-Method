function filtered_ecg=pre_processing_filter_3(data_matrix,total_ecg)

% this filter is designed all by myself. the filter will act as a low pass
% filter
cut_off_1=4;
cut_off_2=30;
edge_band=15;

sampling_freq=1000;
edge_freq=[cut_off_1 cut_off_1+edge_band cut_off_2 cut_off_2+edge_band];
passband_ripple=.001;
stopband_ripple=.001;
filter_cell=firpmord(edge_freq,[0 1 0],[stopband_ripple passband_ripple stopband_ripple],sampling_freq,'cell');
filter_coeff=firpm(filter_cell{:});


for i=1:total_ecg
    filtered_ecg(:,i)=conv(data_matrix(:,i),filter_coeff,'same');
    
%     figure
%     subplot(2,1,1),plot(filtered_ecg(:,i));
%     subplot(2,1,2),plot(data_matrix(:,i));
end
end
% cut_off_1=1;          best values for QRS detection
% cut_off_2=30;
% edge_band=15;

