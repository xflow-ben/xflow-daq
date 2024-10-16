function [y, dydt, ddyddt] = process_counter_voltage_signal(t, x, win, thres, rate, k)
% process_counter_voltage_signal: Processes an counter voltage signal by 
% fitting polynomials over a moving window and computes its first and second derivatives.
%
% INPUTS:
%   t     - Time vector (assumed in seconds)
%   x     - Voltage signal data
%   win   - Window size for polynomial fitting 
%   thres - Voltage threshold to detect signal transitions (counts)
%   rate  - Sampling rate or data rate (in Hz)
%
% OUTPUTS:
%   y     - Counter data (polynomial fit)
%   dy    - First derivative of y (velocity)
%   ddy   - Second derivative of y (acceleration)

% Align time to start at t(1) = 0 for simplicity
t = t - t(1);

% Ensure window size is an even number
win = ceil(win / 2) * 2;

% Step 1: Threshold the signal to create a clean step signal (binary)
% Convert signal to binary: 1 if x > thres, else 0 (clean square wave representation)
x = x > thres;

% Step 2: Compute the differences between consecutive steps in x
% This identifies where transitions from 0 to 1 occur
dx = diff(x);

% Step 3: Detect timestamps (tc) where increments in the signal occur
% dx > 0 identifies rising edges (signal transitions from 0 to 1)
tc = t(dx > 0);

% Step 4: Calculate the corresponding  positions (xc) at each increment
xc = (1:length(tc)) * k;

% Step 5: Interpolate the new scaled counter signal (y) to match the original time vector
y = interp1(tc(~isnan(tc)), xc(~isnan(tc)), t);

% Step 6: Use a polynomial fitting function to compute derivatives
% The function `multipolydiff` performs a moving window polynomial fit and computes
% the first and second derivatives (velocity and acceleration).
% dy: first derivative, ddy: second derivative
[dy, ddy] = multipolydiff(y, win, 2);

% Step 7: Adjust the derivatives by the sampling rate
% Velocity (dy) is divided by the sampling rate (rate)
% Acceleration (ddy) is divided by rate^2 to account for the time scaling
dydt = dy * rate;
ddyddt = ddy * rate^2;

end
