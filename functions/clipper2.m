function clipped_data=clipper2(data_vector,sampling_freq,sensitivity)

data_length=length(data_vector);
clipped_data=data_vector;
if nargin <3
    sensitivity=.1;
elseif nargin<2
    error('input arguements are less than needed');
end

bpm_min=50;  % assumed minimum beats per minute
bpm_max=100;
minutes=length(data_vector)/(60*sampling_freq);
peaks_min=sensitivity*bpm_min*minutes;
peaks_max=sensitivity*bpm_max*minutes;

dummy_data=data_vector;
while_access=1;
limiter_up=5;
limiter_down=0;
start_access=1;
    while while_access==1
        counter=0;
        while_access=0;
        above_limiter=[];
        limiter=mean([limiter_up,limiter_down]);
        counter_access=0;
        for i=1:data_length
            if data_vector(i)>limiter
                above_limiter=[above_limiter,i];
                if counter_access==0
                    counter_access=1;
                    counter=counter+1;
                end
            else
                counter_access=0;
            end
        end
        if start_access==1
            if max(data_vector)>limiter_up
                limiter_up=max(data_vector)*2;
            end
            start_access=0;
        end
        if counter==0
            limiter_up=max(data_vector);
            while_access=1;
%            fprintf('inside counter zero\n');
        elseif counter>0 && counter<peaks_min
            limiter_up=limiter;
            while_access=1;
%            fprintf('inside counter less than peaks_min\n');
        elseif counter>peaks_max
            limiter_down=limiter;
            while_access=1;
%            fprintf('inside counter greater than peaks_max\n');
        else
            clipped_data(above_limiter)=limiter*ones(length(above_limiter),1);
            while_access=0;
%            fprintf('inside counter valid\n');
            limiter_up=5;
            limiter_down=0;
        end
    end
end
