function data_matrix=extract_data(lower_file,upper_file,mit_data)
% this function is to extract excel spreadsheet data and store them in the
% data matrix
if mit_data==1
    for i=lower_file:upper_file
        i
        location=['C:\Users\masud\Documents\MATLAB\MIT BIH database\data\mit_' num2str(i) '.mat'];
        loaded_data=load(location);
        data_temp(:,i-lower_file+1)=loaded_data.val(1,:)';
    end
    data_temp=data_temp-1000*ones(size(data_temp));
else
    for i=lower_file:upper_file
        i
        location=['C:\Users\masud\Documents\MATLAB\thesis_emotion_detection_from_ecg\data_files\dev_' num2str(i) '.txt'];
        fid=fopen(location,'r');
        data=fscanf(fid,'%f');
        fclose(fid);

        data_temp(:,i-lower_file+1)=data;
    end
end
data_matrix=data_temp;
end