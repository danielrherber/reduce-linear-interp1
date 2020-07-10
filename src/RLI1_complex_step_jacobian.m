%--------------------------------------------------------------------------
% RLI1_complex_step_jacobian.m
% Compute sparse Jacobian using complex-step differentiation
%--------------------------------------------------------------------------
% A = RLI1_complex_step_jacobian(fun,x,m)
% fun : functions to be differentiated
%   x : reference point
%   m : number of functions
%   A : sparse gradient
%--------------------------------------------------------------------------
% Derived from MFX 18176 by Yi Cao
% https://www.mathworks.com/matlabcentral/fileexchange/18176
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
function A = RLI1_complex_step_jacobian(fun,x,m)

% number of independent variables
n = numel(x);

% differentiation step size
h = n*eps;

% replicate reference point
X = repmat(x,1,n);

% add complex-step
X = X + h*1i*eye(n);

% initialize
A = zeros(m,n);

% go through each independent variable
for k = 1:n

    % complex-step differentiation
    A(:,k) = imag(fun(X(:,k)))/h;

end

% make A sparse
A = sparse(A);

end