function filtered_ecg=pre_processing_filter_2(data_matrix);

% this pre processing procedure is taken according to the algorithm for QRS
% detection by Pan and Tomkins

% the ecg signal will pass through the filter to remove the higher
% frequency contents in the ecg signal
% here filter coefficients are kept in two vectors A and B
% transfer function is like H(z)=B/A;
% here suppose for A=[higher order coeff ----> lower order coeff]

% low pass filter design 
A=[1 -2 1];
B=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
A_high=[1 1];
B_high=[-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
for i=1:length(data_matrix(1,:))
    low_filtered_ecg=filter(B,A,data_matrix(:,i));
    filtered_ecg(:,i)=filter(B_high,A_high,low_filtered_ecg);
    figure(i)
    subplot(3,1,3),plot(filtered_ecg(:,i));
end
end