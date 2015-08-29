function xc = getHistogramBins(sensor)
    
    nHCenters = round(sensor.maxRange/sensor.rangeRes)+1; % number of histogram centers
    xc = linspace(0,sensor.maxRange,nHCenters); % histogram centers
end