function [dy,ddy] = multipolydiff(y,win,n)
% Moving window differentiator for real data
% Performs least squared fit of polynomial of degree n over windows of
% length win, finds analytical derivatives, evaluates at midpoint of window
% (except win/2 endpoints)

% INPUTS:
%   y: data to differentiate
%   win: window size (default is 11)
%   n: degree of polynomial (default is 2)

% OUTPUTS
%   dy: first derivative of y
%   ddy: second derivative of y

% Benjamin Strom, 2021

% check inputs
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

dy=zeros(dn,1);
ddy=zeros(dn,1);

% Construct the Vandermonde matrix V = [x.^n ... x.^2 x ones(size(x))]
V(:,n+1) = ones(win,1,class(y));
for j = n:-1:1
    V(:,j) = (1:win)'.*V(:,j+1);
end

% do QR factorization of Vandermonde first
[Q,R] = qr(V,0);
Q = Q';

for i=1:dn-2*wr
    c = R\(Q*y(i:win+i-1));
    for j=1:n
        dc=c(n-j+1)*j;
        dy(i+wr)=dy(i+wr)+dc*(wr+1)^(j-1);
    end
    for j=1:n-1
        ddc=c(n-j)*j*(j+1);
        ddy(i+wr)=ddy(i+wr)+ddc*(wr+1)^(j-1);
    end
end

% take care of first end last window/2 points
for i = 1:wr
    if i == 1
        dy(1) = y(2) - y(1);
        dy(end) = y(end) - y(end-1);
    elseif i == 2
        p = polyfit([1 2 3],y(1:3)',2);
        dy(2) = 2*p(1)*2+p(2);
        ddy(1:2) = 2*p(1);
        
        p = polyfit([1 2 3],y(end-2:end)',2);
        dy(end-1) = 2*p(1)*2+p(2);
        ddy(end-1:end) = 2*p(1);
    else
        dy(i) = 0;
        dy(end-i+1) = 0;
        ddy(i) = 0;
        ddy(end-i+1) = 0;
        p1 = polyfit(1:i*2-1,y(1:i*2-1)',n);
        p2 = polyfit(1:i*2-1,y(end-(2*i-2):end)',n);
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
    dy=reshape(dy,rsy);
    ddy=reshape(ddy,rsy);
end
end