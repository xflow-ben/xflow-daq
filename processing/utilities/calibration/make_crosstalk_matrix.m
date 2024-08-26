function crosstalk_matrix = make_crosstalk_matrix(fits,relatedLoad_calib_names,relatedLoad_chan_names,load_name)

% based on https://hitec.humaneticsgroup.com/perspectives/cross-talk-compensation-using-matrix-methods
%%
for i =1:length(relatedLoad_calib_names)
    for j =1:length(relatedLoad_chan_names)
        calib_ind = find(strcmp(load_name,relatedLoad_calib_names{i}));
        chan_ind = find(strcmp(fits(calib_ind).chan_name,relatedLoad_chan_names{j}));
        output_matrix(i,j) = fits(calib_ind).slope(chan_ind);
    end
end

crosstalk_matrix = inv(output_matrix);

