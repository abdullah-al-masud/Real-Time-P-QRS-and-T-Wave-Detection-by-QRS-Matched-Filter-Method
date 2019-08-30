% this code id written for ecg to emotion detection and intended to convert
% the provided excel data to a simple text format to load the data more
% effeciently and faster

clear all
close all
clc
number_of_files=9;
for i=1:number_of_files
    i
    location=['C:\Users\masud\Documents\MATLAB\thesis_emotion_detection_from_ecg\data_files\filtered\train_' num2str(i) '.csv'];
    fid=fopen(location);
    data=textscan(fid,'%s%s%s','delimiter',';');
    fclose(fid);
    
    data_temp(:,i)=str2double(data{3});
end
data_matrix=data_temp(2:length(data_temp(:,1)),:);

fprintf('------the data is extracted from excel spreadsheet  --------------\n');

for i=1:number_of_files
    location=['C:\Users\masud\Documents\MATLAB\thesis_emotion_detection_from_ecg\data_files\filtered\dev_' num2str(9*2+i) '.txt'];
    fid=fopen(location,'w');
    fprintf(fid,'%f\n',data_matrix(:,i));
    fclose(fid);
end

fprintf('------the data is written in text format  --------------\n');