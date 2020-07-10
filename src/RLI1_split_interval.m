%--------------------------------------------------------------------------
% RLI1_split_interval.m
% Applies a recursive algorithm to find a reduced number of X points that
% still linearly interpolates a 1D dataset within an absolute error
% tolerance
%--------------------------------------------------------------------------
% [xi,yi] = RLI1_split_interval(X,Y,tol,xi,yi,optflag,fmbopts)
%       X : original independent data points
%       Y : original dependent data points
%     tol : absolute error tolerance
%      xi : list of X dimension sample points
%      yi : list of Y dimension sample points
% optflag : optimization flag for interior point (true/false)
% fmbopts : options for fminbnd
%      xi : updated list of X dimension sample points
%      yi : updated list of Y dimension sample points
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
function [xi,yi] = RLI1_split_interval(X,Y,tol,xi,yi,optflag,fmbopts)

% number of data points in current interval
N = length(X);

% check if a trivial interval
if N <= 3

    % save because there is no error
    xi = [xi,X]; yi = [yi,Y];

    % exit the function
    return

end

% calculate the X midpoint of the interval
mid = X(1) + (X(end)-X(1))/2;

% find the closest X value to the midpoint
[~,k] = min(abs(X-mid));

% 3 candidate x and y values
x = [X(1) X(k) X(end)];
y = [Y(1) Y(k) Y(end)];

% find the best value for the interior point
if optflag

    % distance must be within the tolerance
    miny = y(2) - tol; maxy = y(2) + tol;

    % find optimal y value for the interior point
    [opty,maxerror] = fminbnd(@(midy) EvalMidpointError(midy,x,y,X,Y),miny,maxy,fmbopts);

    % set the optimal value as the central y value
    y(2) = opty;

else

    % calculate maximum absolute error
    maxerror = max(abs(Y - interp1(x,y,X,'linear')));

end

% check if the error is acceptable
if maxerror > tol % not acceptable, split into 2 intervals

    % left interval
    [xi,yi] = RLI1_split_interval(X(1:k),Y(1:k),tol,xi,yi,optflag,fmbopts);

    % right interval
    [xi,yi] = RLI1_split_interval(X(k:end),Y(k:end),tol,xi,yi,optflag,fmbopts);

else % acceptable error

    % save the current x and y points
    xi = [xi,x]; yi = [yi,y];

end

end

% calculate error of tunable central y value
function f = EvalMidpointError(midy,x,y,X,Y)

% set the candidate value as the central y value
y(2) = midy;

% compute error
e = Y - interp1(x, y, X, 'linear');

% squared error
f = max(abs(e));

end