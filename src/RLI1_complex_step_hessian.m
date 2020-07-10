%--------------------------------------------------------------------------
% RLI1_complex_step_hessian.m
% Compute sparse tridiagonal Hessian and gradient using complex-step
% differentiation
%--------------------------------------------------------------------------
% [H,g] = RLI1_complex_step_hessian(fun,x)
% fun : function to be differentiated
%   x : reference point
%   H : sparse tridiagonal Hessian
%   g : sparse gradient
%--------------------------------------------------------------------------
% Derived from MFX 18177 by Yi Cao
% https://www.mathworks.com/matlabcentral/fileexchange/18177
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
function [H,g] = RLI1_complex_step_hessian(fun,x)

% size of independent
n = numel(x);

% initialize
H = zeros(n,n); g = zeros(n,1);

% differentiation step size
h = sqrt(eps);

% square of step size
h2 = 2*h*h;

% go through each independent variable
for ix = 1:n

    % reference point
    x1 = x;

    % increment in ith independent variable
    x1(ix) = x1(ix) + h*1i;

    % complex-step differentiation for gradient
    g(ix) = imag(fun(x1))/h;

    % handle final entry differently
    if ix == n
        Ij = n;
    else
        Ij = ix:ix+1;
    end

    % go through each tridiagonal
    for jx = Ij

        % reference with kth increment
        x2 = x1;

        % ith + jth increments
        x2(jx) = x2(jx) + h;
        u1 = fun(x2);
        x2(jx) = x1(jx) - h;
        u2 = fun(x2);

        % compute Hessian entry with central + complex step
        H(ix,jx) = imag(u1-u2)/h2;

        % make symmetric
        H(jx,ix) = H(ix,jx);

    end

end

% make H and g sparse
H = sparse(H); g = sparse(g);

end