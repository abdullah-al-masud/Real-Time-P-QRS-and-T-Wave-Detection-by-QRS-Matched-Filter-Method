function [p_wave_peaks , t_wave_peaks]=p_and_t_wave_detection(data_matrix, filtered_ecg, qrs_peaks, total_peaks, sampling_freq)

[data_length , total_ecg]=size(data_matrix);
p_wave_peaks=zeros(data_length , total_ecg);
t_wave_peaks=p_wave_peaks;

%% this part is for P wave detection And T wave detection

% I am generating a triangular shaped signal to cross correlate to the main
% signal to find P wave and T wave..... 
% the standard duration of these waves are around .1 seconds 
% so we will have the length of triangular filter as .1 seconds
% also typical QRS width is also .1 seconds
% so to find out p and t waves I atfirst remove the data of .05 seconds
% around both side of each QRS peak
triangular_duration=.1*sampling_freq;
init_filter_coeffs=-triangular_duration/2:triangular_duration/2;
% filter_length=length(init_filter_coeffs);
triangular_filter=((-abs(init_filter_coeffs)+triangular_duration/2*ones(1,triangular_duration+1))/(triangular_duration/2))';

%data needed for p and t wave peak detection
qrs_radius=round(triangular_duration/2);
subtr_filtered_ecg=data_matrix-filtered_ecg;
ecg_for_pt_wave=subtr_filtered_ecg+repmat(abs(min(subtr_filtered_ecg)),data_length,1);
correlated_data=zeros(data_length , total_ecg);

for i=1:total_ecg
    correlated_data(:,i)=conv(ecg_for_pt_wave(:,i),triangular_filter,'same');
    zero_positions=[];
    zero_index=0;   % this variable is meant to store the index of the peak lying inside the qrs radius from the beginning of the data
    counter=0;   % this counter variable will count the number of qrs at the very first positions
    all_qrs=find(qrs_peaks(:,i)==1);

    for j=1:total_peaks(i)
        if all_qrs(j)<=qrs_radius
            zero_index=j;
            counter=counter+1;
        else
            if all_qrs(j)+qrs_radius<=data_length
                zero_positions=[zero_positions all_qrs(j)-qrs_radius:all_qrs(j)+qrs_radius];
            else
                zero_positions=[zero_positions all_qrs(j)-qrs_radius:data_length];
            end
        end
    end
    if zero_index~=0
        correlated_data(1:all_qrs(zero_index)+qrs_radius,i)=zeros(all_qrs(zero_index)+qrs_radius,1);
    end
    correlated_data(zero_positions,i)=zeros(length(zero_positions),1);
%     figure()
%     plot(correlated_data(:,i))
end
% now we have data signal qrs_left_corr which is devoid of QRS peaks which will be helpful to
% find p and t wave peaks
qrs_left_corr=correlated_data;

%% in this part we will try to find the positions of the p wave peak and t wave peak

for i=1:total_ecg
    zero_count=0;
    local_peaks=[];
    inside_zero=1;  % its a flag that will indicate whether the present state is inside zero region or outside zero region
    rising_state=0;
    p_positions=[];
    t_positions=[];
    p_average_dist=90;   % average distance from the nearest qrs zero in samples
    t_average_dist=180;
    
    for j=2:data_length
        if qrs_left_corr(j,i)~=0
            if inside_zero==1
                inside_zero=0;
                zero_end=j-1;
                j=j+1;
            end
            present_difference=qrs_left_corr(j,i)-qrs_left_corr(j-1,i);
            if present_difference<0 && rising_state==1
                rising_state=0;
                local_peaks=[local_peaks j];
            elseif present_difference>0 && rising_state==0
                rising_state=1;
            end
            if j==data_length    % this portion is meant for the last data of the ecg signal
                zero_count=zero_count+1;
                zero_start=j;
                if length(local_peaks)>=2
                    p_positions=[p_positions max(local_peaks)];
                    t_positions=[t_positions min(local_peaks)];
                elseif length(local_peaks)==1
                    t_positions=[t_positions local_peaks];
                end
                    
            end
        else
            if inside_zero==0
                rising_state=0;
                inside_zero=1;
                zero_count=zero_count+1;
                zero_start=j;
                if zero_count==1
                    if length(local_peaks)>=2
                        p_positions=[p_positions max(local_peaks)];
                        t_positions=[t_positions min(local_peaks)];
                        p_average_dist=round((p_average_dist+(zero_start-max(local_peaks)))/2);
                        t_average_dist=round((t_average_dist+(min(local_peaks)-zero_end))/2);
                    elseif length(local_peaks)==1
                        p_positions=[p_positions local_peaks];
                        p_average_dist=round((p_average_dist+(zero_start-local_peaks))/2);
                    end
                else
                    if length(local_peaks)>=2
                        p_positions=[p_positions max(local_peaks)];
                        t_positions=[t_positions min(local_peaks)];
                        p_average_dist=round((p_average_dist+(zero_start-max(local_peaks)))/2);
                        t_average_dist=round((t_average_dist+(min(local_peaks)-zero_end))/2);
                    elseif length(local_peaks)==1
                        if zero_start-local_peaks<local_peaks-zero_end
                            p_average_dist=round((p_average_dist+zero_start-local_peaks)/2);
                            t_average_dist=t_average_dist;
                            p_positions=[p_positions local_peaks];
                            t_positions=[t_positions zero_end+t_average_dist];  %%%%%%%%%
                        else
                            p_average_dist=p_average_dist;
                            t_average_dist=round((t_average_dist+local_peaks-zero_end)/2);
                            t_positions=[t_positions local_peaks];
                            p_positions=[p_positions zero_start-p_average_dist];  %%%%%%%%%%%
                        end
                    end
                    
                    local_peaks=[];
                end
            end
        end
    end
    i
    total_p(i)=length(p_positions)
    total_t(i)=length(t_positions)
    qrs_positions=find(qrs_peaks(:,i)==1);
    
    p_wave_peaks(p_positions ,i)=ones(total_p(i),1);
    t_wave_peaks(t_positions ,i)=ones(total_t(i),1);
    figure()
    plot(data_matrix(:,i))
    hold on
    stem(p_positions,2*data_matrix(p_positions,i),'.r')
    hold on
    stem(t_positions,2*data_matrix(t_positions,i),'.g')
    hold on
    stem(qrs_positions,2*data_matrix(qrs_positions,i),'.k')
    hold off
end


end