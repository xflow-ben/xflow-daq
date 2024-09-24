 clear all
 
 
 data = [1 2 3 4];
 dataColumns = {'a','b','c','d'};

 cal.type = 'linear_k';
 cal.input_channels = {'a','b','c'};
  cal.output_names = {'A','B'};
 cal.data.k = [1 0;
     10 1;
     1 0];
 out = apply_calibration(data,dataColumns,cal)