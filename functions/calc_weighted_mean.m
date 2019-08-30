function weighted_mean=calc_weighted_mean(data_vector)

%% this function will find the exponentially weighted average of a given data vector
data_vector=data_vector(:);
data_length=length(data_vector);
%weights=fliplr(exp(-[1:data_length]));
weights=ones(1,data_length);
sum_weights=sum(weights);
weighted_mean=(weights*data_vector)/sum_weights;


end