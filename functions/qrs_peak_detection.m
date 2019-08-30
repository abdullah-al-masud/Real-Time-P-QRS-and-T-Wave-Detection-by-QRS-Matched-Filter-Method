function [cleaned_qrs_peaks , total_peaks]=qrs_peak_detection(filtered_data,sampling_freq)
%function [qrs_peaks , total_peaks]=qrs_peak_detection(filtered_data,sampling_freq)

[data_length, total_ecg]=size(filtered_data);

time_per_chunk=10;  % the time is considered in seconds
down_shift_factor=.6;

total_peaks=zeros(total_ecg,1);
qrs_peaks=zeros(data_length,total_ecg);

chunk_length=time_per_chunk*sampling_freq;
total_chunk=ceil(data_length/chunk_length);
if mod(data_length,chunk_length)~=0
   extra_length=total_chunk*chunk_length-data_length;
   extra_data=zeros(extra_length,1);
   filtered_data=[filtered_data ; repmat(extra_data,1,total_ecg)];
    
end
for i=1:total_ecg
    positioned_peaks=[];
%    fprintf('figure %d appears now -------\n',i);
%     pause();
%     figure();
% i
    for j=1:total_chunk
%         j
        plot_xval=(j-1)*chunk_length+1:j*chunk_length;
        hwr_data=half_wave_rectifier(filtered_data(plot_xval,i));
%         subplot(4,1,1),plot(plot_xval,hwr_data);
%         title('half wave rectified');
        clipped_data=clipper2(hwr_data,sampling_freq);
%         subplot(4,1,2),plot(plot_xval,clipped_data);
%         title('clipped by clipper2()');
        normalized_data=exp(data_normalization(clipped_data));
        down_shifted_data=normalized_data-down_shift_factor*max(normalized_data)*ones(chunk_length,1);
        hwr_data=half_wave_rectifier(down_shifted_data);
%         subplot(4,1,3),plot(plot_xval,hwr_data);
%         title('hwr after down shifting');
        peaks_found=find_peak(hwr_data);
        peak_vector=zeros(chunk_length,1);
        peak_vector(peaks_found)=ones(length(peaks_found),1);
%         subplot(4,1,4),stem(plot_xval,peak_vector,'.k');
%         title('peaks');
        positioned_peaks=[positioned_peaks ; (j-1)*chunk_length*ones(length(peaks_found),1)+peaks_found];
%         pause();
    end
    qrs_peaks(positioned_peaks,i)=ones(size(positioned_peaks));
%    total_peaks(i)=length(positioned_peaks);
end
[cleaned_qrs_peaks , total_peaks]=cleaning_qrs_peaks(qrs_peaks);
end

