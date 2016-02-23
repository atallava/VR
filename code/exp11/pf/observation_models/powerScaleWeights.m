function weights = powerScaleWeights(weights,powerScale)
    %POWERSCALEWEIGHTS
    %
    % weights = POWERSCALEWEIGHTS(weights,powerScale)
    %
    % weights    - Vector. Scalar.
    % powerScale -
    %
    % weights    - Vector.

    weights = weights.^powerScale;
end