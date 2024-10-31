function [yout, dy, ddy] = multipolydiffNaN(y, win, n)
if nargin<3
    n=2;
end

if nargin<2
    win=11;
end

if length(y)<win
    error('Input y must be at least as long window')
end

% make window odd so point of interest is at center
if mod(win,2)~=1
    win=win+1;
end

wr=floor(win/2);
dn=length(y);
if size(y,2) > size(y,1)
    rsy=size(y);
    y=reshape(y,[dn,1]);
else
    rsy = 0;
end

yout = zeros(dn,1);
dy=zeros(dn,1);
ddy=zeros(dn,1);

for i=1:dn-2*wr

    ytemp = y(i:win+i-1);
    xtemp = 1:win;

    xtemp = xtemp(~isnan(ytemp));
    ytemp = ytemp(~isnan(ytemp));

    if length(xtemp) < n
        % yout = NaN;
        dy(i+wr) = NaN;
        ddy(i+wr) = NaN;
    else

        dy(i+wr) = 0;
        ddy(i+wr) = 0;
        p = polyfit(xtemp,ytemp,n);
        yout(i+wr) = polyval(p,wr+1);
    for j=1:n
        dc=p(n-j+1)*j;
        dy(i+wr)=dy(i+wr)+dc*(wr+1)^(j-1);
    end
    for j=1:n-1
        ddc=p(n-j)*j*(j+1);
        ddy(i+wr)=ddy(i+wr)+ddc*(wr+1)^(j-1);
    end

    end

end

for i = 1:wr
    if i == 1
        yout(1) = y(1);
        dy(1) = y(2) - y(1);
        dy(end) = y(end) - y(end-1);
    elseif i == 2

        p = polyfit([1 2 3],y(1:3)',2);
        yout(2) = polyval(p,2);
        dy(2) = 2*p(1)*2+p(2);
        ddy(1:2) = 2*p(1);

        p = polyfit([1 2 3],y(end-2:end)',2);
        yout(end-1) = polyval(p,2);
        dy(end-1) = 2*p(1)*2+p(2);
        ddy(end-1:end) = 2*p(1);
    else
        dy(i) = 0;
        dy(end-i+1) = 0;
        ddy(i) = 0;
        ddy(end-i+1) = 0;
        p1 = polyfit(1:i*2-1,y(1:i*2-1)',n);
        p2 = polyfit(1:i*2-1,y(end-(2*i-2):end)',n);
        yout(i) = polyval(p1,n-j+1);
        yout(end-i+1) = polyval(p2,n-j+1);
        for j = 1:length(p1)-1
            dy(i) = dy(i) + (n-j+1)*p1(j)*i^(n-j);
            dy(end-i+1) = dy(end-i+1) + (n-j+1)*p2(j)*i^(n-j);
        end
        for j = 1:length(p1)-2
            ddy(i) = ddy(i) + (n-j+1)*(n-j)*p1(j)*i^(n-j-1);
            ddy(end-i+1) = ddy(end-i+1) + (n-j+1)*(n-j)*p2(j)*i^(n-j-1);
        end
    end
end


if rsy ~= 0
    yout = reshap(yout,rsy);
    dy=eshape(dy,rsy);
    ddy=reshape(ddy,rsy);
end


end
% function [yout, dy, ddy] = multipolydiffNaN(y, win, n)
%     % Default settings
%     if nargin < 3, n = 2; end
%     if nargin < 2, win = 11; end
%     if length(y) < win, error('Input y must be at least as long as the window size'); end
%     if mod(win, 2) ~= 1, win = win + 1; end % Make window odd
% 
%     wr = floor(win / 2);
%     dn = length(y);
%     y = y(:); % Ensure column vector
% 
%     % Initialize output arrays
%     yout = NaN(dn, 1);
%     dy = NaN(dn, 1);
%     ddy = NaN(dn, 1);
% 
%     % Precompute power factors for derivatives
%     dy_factors = (wr + 1).^(0:n-1);
%     ddy_factors = (wr + 1).^(0:n-2);
% 
%     % Process the main body of the data
%     for i = 1:dn - 2 * wr
%         ytemp = y(i:win + i - 1);
%         xtemp = (1:win)'; % Column vector
% 
%         % Remove NaNs from ytemp and xtemp
%         valid_idx = ~isnan(ytemp);
%         ytemp = ytemp(valid_idx);
%         xtemp = xtemp(valid_idx);
% 
%         if length(xtemp) >= n + 1
%             % Create Vandermonde matrix for least-squares fitting
%             V = ones(length(xtemp), n + 1);
%             for j = n:-1:1
%                 V(:, j) = xtemp .* V(:, j + 1);
%             end
% 
%             % Solve for polynomial coefficients using backslash operator
%             p = V \ ytemp;
% 
%             % Evaluate polynomial at center
%             yout(i + wr) = polyval(p', wr + 1);
% 
%             % Compute derivatives at center
%             dy(i + wr) = sum((n:-1:1) .* p(1:end-1)' .* dy_factors);
%             ddy(i + wr) = sum((n:-1:2) .* (n-1:-1:1) .* p(1:end-2)' .* ddy_factors);
%         end
%     end
% 
%     % Handle edge cases with small windows and `polyfit`
%     for i = 1:wr
%         if i == 1
%             yout(1) = y(1);
%             dy(1) = y(2) - y(1);
%             dy(end) = y(end) - y(end - 1);
%         elseif i == 2
%             p_left = polyfit([1 2 3], y(1:3)', 2);
%             yout(2) = polyval(p_left, 2);
%             dy(2) = 2 * p_left(1) * 2 + p_left(2);
%             ddy(1:2) = 2 * p_left(1);
% 
%             p_right = polyfit([1 2 3], y(end-2:end)', 2);
%             yout(end-1) = polyval(p_right, 2);
%             dy(end-1) = 2 * p_right(1) * 2 + p_right(2);
%             ddy(end-1:end) = 2 * p_right(1);
%         else
%             p1 = polyfit(1:i*2-1, y(1:i*2-1)', n);
%             p2 = polyfit(1:i*2-1, y(end-(2*i-2):end)', n);
%             yout(i) = polyval(p1, i);
%             yout(end-i+1) = polyval(p2, i);
% 
%             for j = 1:length(p1) - 1
%                 dy(i) = dy(i) + (n - j + 1) * p1(j) * i^(n - j);
%                 dy(end-i+1) = dy(end-i+1) + (n - j + 1) * p2(j) * i^(n - j);
%             end
%             for j = 1:length(p1) - 2
%                 ddy(i) = ddy(i) + (n - j + 1) * (n - j) * p1(j) * i^(n - j - 1);
%                 ddy(end-i+1) = ddy(end-i+1) + (n - j + 1) * (n - j) * p2(j) * i^(n - j - 1);
%             end
%         end
%     end
% 
%     % Restore original shape if input was a row vector
%     if size(y, 2) > size(y, 1)
%         yout = yout';
%         dy = dy';
%         ddy = ddy';
%     end
% end
