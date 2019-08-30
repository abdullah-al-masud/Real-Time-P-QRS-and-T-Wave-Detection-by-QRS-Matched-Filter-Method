function aligned_qrs_peaks=aligning_qrs(data_matrix,qrs_peaks,sampling_freq)

% this function will check whether the peaks we found is aligned to the
% actual peaks or not and if any peak is not aligned to the actual R peak
% then it will be aligned here

[data_length, total_ecg]=size(data_matrix);
dev_time=80;  % its maximum allowable deviation time within which the alignment can be performed
                % in milli seconds
dev_length=round(dev_time/1000*sampling_freq);

actual_qrs_peaks=[];
for i=1:total_ecg
    present_qrs=find(qrs_peaks(:,i)==1);
    actual_qrs=present_qrs;
    
    for j=1:length(present_qrs)
        chunked_data=data_matrix(present_qrs(j)-dev_length:present_qrs(j)+dev_length,i);
        % its the chunk taken to check alignment
        maximum=max(chunked_data);
        if maximum~=data_matrix(present_qrs(j),i)
            max_index=find(chunked_data==maximum);
            actual_qrs(j)=present_qrs(j)-(dev_length+1)+max_index(1);  
            % max_index(1) is taken as sometimes max_index becomes an array
        end
    end
    actual_qrs_peaks=[actual_qrs_peaks; actual_qrs(:)];
end

aligned_qrs_peaks=zeros(data_length,total_ecg);
aligned_qrs_peaks(actual_qrs_peaks)=ones(size(actual_qrs_peaks));

end