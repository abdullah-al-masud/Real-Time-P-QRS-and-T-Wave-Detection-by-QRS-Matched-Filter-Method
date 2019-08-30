function frequency_analysis(data_matrix,total_data,sampling_freq);

tic
% here we will try to analize the frequency contentc and try to understand
% how to minimize noises and get a good shape of all waves 

length_factor=4;
data_length=floor(length(data_matrix(:,1))/length_factor);
freq=sampling_freq*[1:data_length]/data_length;

%dft_mat=dftmtx(data_length);
% data_fft=data_matrix'*dft_mat;
% data_fft=data_fft';

data_fft=fft(data_matrix);

% cut_off=60;
% cut_off_index=round(cut_off/sampling_freq*data_length);
% zero_vec=zeros(data_length,1);
% zero_vec(1:cut_off_index)=ones(cut_off_index,1);
% zero_vec(data_length-cut_off_index+1:data_length)=ones(cut_off_index,1);
% zero_mat=repmat(zero_vec,1,total_data);
% 
% low_filtered_data_fft=data_fft.*zero_mat;
% 
% time_data=ifft(low_filtered_data_fft);

% figure(total_data+1)
for i=1:total_data
    figure
    stem(freq(1:data_length/2),abs(data_fft(1:data_length/2,i)));
%     subplot(total_data,2,2*i),plot(abs(time_data(:,i)));
end

toc
end