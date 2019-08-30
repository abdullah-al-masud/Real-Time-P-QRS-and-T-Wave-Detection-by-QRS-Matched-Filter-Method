function qrs_peaks=find_peak(hwr_subtracted_data)
% this function will find the QRS peaks from the half wave rectified and
% subtracted waveform of the ecg signal
% input data might be a matrix


[data_length, total_ecg]=size(hwr_subtracted_data);

starting_problem=0;
ending_problem=0;

    loop_start=2;
    if hwr_subtracted_data(1)==0
        zero_running=1;
    else
        zero_running=0;
        if hwr_subtracted_data(2)-hwr_subtracted_data(1)>0
            % this portion is meant for starting value problem
            starting_problem=1;
            while hwr_subtracted_data(loop_start)-hwr_subtracted_data(loop_start-1)>0
                loop_start=loop_start+1;
            end
            peak_start=loop_start-1;
        end
        while hwr_subtracted_data(loop_start)~=0
            loop_start=loop_start+1;
        end
        zero_running=1;
    end
    
    % this portion is to check the ending value problem
    loop_end=data_length;
    if hwr_subtracted_data(loop_end)~=0
        if hwr_subtracted_data(loop_end-1)-hwr_subtracted_data(loop_end)>0
            ending_problem=1;
            while hwr_subtracted_data(loop_end-1)-hwr_subtracted_data(loop_end)>0
                loop_end=loop_end-1;
            end
            peak_end=loop_end;
        end
        while hwr_subtracted_data(loop_end)~=0
            loop_end=loop_end-1;
        end
    end
    
    peak_down=0;
    peak_up=0;
    for j=loop_start:loop_end
        if zero_running==0 && hwr_subtracted_data(j)==0
            zero_running=1;
            peak_down=[peak_down j];
        elseif zero_running==1 && hwr_subtracted_data(j)~=0
            zero_running=0;
            peak_up=[peak_up j-1];
        end
    end
        length_peakup =length(peak_up);
        length_peakdown =length(peak_down);
        if length_peakup>length_peakdown
            peak_up=peak_up(2:length_peakup-1);
            peak_down=peak_down(2:length_peakdown);
            up_small=-1;
        elseif length_peakup<length_peakdown
            peak_down=peak_down(2:length_peakdown-1);
            peak_up=peak_up(2:length_peakup);
            up_small=1;
        else
            peak_up=peak_up(2:length_peakup);
            peak_down=peak_down(2:length_peakdown);
            up_small=0;
        end
        qrs_peaks=round(mean([peak_up ; peak_down]))';
%         if up_small==-1
%             qrs_peaks(1:length_peakdown-1)=mean_peak';
%         else 
%             qrs_peaks(1:length_peakup-1)=mean_peak';
%         end
        if starting_problem==1
            qrs_peaks=[peak_start ; qrs_peaks];
        end
        if ending_problem==1
            qrs_peaks=[qrs_peaks ; peak_end];
        end
        
        % post processing to remove unwanted peaks
        
        
%         total_peaks=length(qrs_peaks);
%         for i=1:total_peaks-1
%             peak_distances(i)=qrs_peaks(i+1)-qrs_peaks(i);
%         end
%         mean_distance=mean(peak_distances);
%         standard_dev=std(peak_distances);
%         
%         for i=2:total_peaks
%             if qrs_peaks(i)
%             end
%         end

end

