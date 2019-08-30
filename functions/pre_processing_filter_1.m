function filtered_ecg=pre_processing_filter_1(data_matrix , total_ecg)

% this pre processing procedure is taken from the algorithm developed by
% Abdullah Arafat and Kamrul hasan sir 

% the ecg signal will pass through the filter to remove the higher
% frequency contents in the ecg signal
% here filter coefficients are kept in two vectors A and B
% transfer function is like H(z)=B/A;
% here suppose for A=[higher order coeff ----> lower order coeff]


A=1;
B=[.8 .1 .1 ];
B_rev=fliplr(B);
for i=1:total_ecg
    temp_filtered=filter(B_rev,A,data_matrix(:,i));
    filtered_ecg(:,i)=filter(B_rev,A,temp_filtered);
    figure(i)
    subplot(3,1,1),plot(data_matrix(:,i));
    subplot(3,1,2),plot(filtered_ecg(:,i))
end
end