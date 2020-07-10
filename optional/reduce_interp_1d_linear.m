%--------------------------------------------------------------------------
% reduce_interp_1d_linear.m
% Applies a recursive algorithm to find a reduced number of X points that
% still linearly interpolates a 1D dataset within an absolute error
% tolerance
%--------------------------------------------------------------------------
% [xi,yi] = reduce_linear_interp1(X,Y,tol,varargin)
%          X : original independent sample points
%          Y : original dependent sample points
%        tol : absolute error tolerance
% varargin{1}: options structure (see below)
%         xi : reduced list of independent sample points
%         yi : reduced list of dependent sample points
%--------------------------------------------------------------------------
% NOTE: this function is provided to maintain compatibility with the
% previous name
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
function [xi,yi] = reduce_interp_1d_linear(X,Y,tol,varargin)

% call the new function name
[xi,yi] = reduce_linear_interp1(X,Y,tol,varargin{:});

end