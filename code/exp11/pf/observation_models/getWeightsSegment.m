function w = getWeightsSegment(n)
    % n is the span of the segment
    if mod(n,2) == 0
        error('n required to be odd');
    end
    % weights are in the 2-sigma span
    w = normpdf(linspace(-2,2,n));
    % normalize weights
    w = w/sum(w);
end