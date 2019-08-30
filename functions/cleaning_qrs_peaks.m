function [cleaned_qrs_peaks , total_peaks]=cleaning_qrs_peaks(qrs_peaks)

max_deviation=.7;  % means 70% deviation will be allowed
max_back_peaks=5;

[data_length, total_ecg]=size(qrs_peaks);
cleaned_qrs_peaks=zeros(data_length , total_ecg);

for i=1:total_ecg
    peak_positions=find(qrs_peaks(:,i)==1);
    last_peak_position=peak_positions(length(peak_positions));
    cleaned_peaks=[0 0];
    distances=[0];
    cleaned_peaks(1:2)=peak_positions(1:2);
    distances(1)=cleaned_peaks(2)-cleaned_peaks(1);
    present_peak_position=peak_positions(2);
    peak_counter=2;
    
    while present_peak_position<last_peak_position
        if peak_counter<=max_back_peaks+1
            average_distance=round(calc_weighted_mean(distances));
        else
            average_distance=round(calc_weighted_mean(distances(peak_counter-1-max_back_peaks:peak_counter-1)));
        end
        assumed_peak_center=present_peak_position+average_distance;
        dev_length=round(average_distance*max_deviation);
        peak_finder=0;
        while peak_finder<=dev_length
            if assumed_peak_center-peak_finder<=data_length
                if qrs_peaks(assumed_peak_center-peak_finder,i)==1
                    present_peak_position=assumed_peak_center-peak_finder;
                    distances=[distances average_distance-peak_finder];
                    cleaned_peaks=[cleaned_peaks present_peak_position];
                    break;
                end
            end
            if assumed_peak_center+peak_finder<=data_length
                if qrs_peaks(assumed_peak_center+peak_finder,i)==1
                    present_peak_position=assumed_peak_center+peak_finder;
                    distances=[distances average_distance+peak_finder];
                    cleaned_peaks=[cleaned_peaks present_peak_position];
                    break;
                end
            end
            peak_finder=peak_finder+1;
        end
        if peak_finder==dev_length+1
            present_peak_position=assumed_peak_center;
            distances=[distances average_distance];
            cleaned_peaks=[cleaned_peaks present_peak_position];
        end
        peak_counter=peak_counter+1;
    end
    cleaned_qrs_peaks(cleaned_peaks,i)=ones(peak_counter,1);
    total_peaks(i)=peak_counter;
end



end