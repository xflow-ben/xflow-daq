function yi = interp1_with_closest_extrap(x, y, xi)
    % Interpolate with linear interpolation and closest value for extrapolation
    
    % Perform the interpolation
    yi = interp1(x, y, xi, 'linear', 'extrap');
    
    % Get the nearest value for extrapolation
    if any(xi < min(x)) % Extrapolating below the range
        yi(xi < min(x)) = y(find(x == min(x)));
    elseif any(xi > max(x)) % Extrapolating above the range
        yi(xi > max(x)) = y(find(x == max(x)));
    end
end