%--------------------------------------------------------------------------
% reduce_linear_interp1.m
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
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
function [xi,yi] = reduce_linear_interp1(X,Y,tol,varargin)

% parse the varargin options structure
opts = varargin; opts = parse_inputs(opts);

% display original size
if opts.display_flag
    disp(['Original Data Length: ',int2str(length(X))])
    disp('   Finding reduced number of points maintaining error tolerance...')
end

% ensure row vectors for the data
X = X(:)'; Y = Y(:)';

% call the recursive splitting algorithm to find the reduced data set
[xi,yi] = RLI1_split_interval(X,Y,tol,[],[],opts.interior_optflag,opts.fminbnd);

% display finished
if opts.display_flag
    disp('   ...Finished!')
end

% splitting algorithm contains duplicate xi points so remove them
[xi,Ix,~] = unique(xi); % extract only the unique xi points
yi = yi(Ix); % remove the corresponding yi values

% display some plots
if opts.display_flag

    % plot type 1 in the script
    plotflag = 1; %#ok<NASGU>

    % create the plots
    RLI1_plots

end

% find the optimal yi with respect to mean squared error at fixed xi locations
if opts.post_optflag

    % number of original time points
    nX = length(X);

    % squared error objective function and error function
    objfun = @(xi,yi,X,Y) sum((interp1(xi,yi,X,'linear') - Y).^2);
    errorfun = @(xi,yi,X,Y) interp1(xi,yi,X,'linear') - Y;

    % find the Hessian and gradient of the squared error objective
    [H,f] = RLI1_complex_step_hessian(@(yi) objfun(xi,yi,X,Y),yi');

    % compute the Jacobian of the linear maximum allowable error
    Jyi = RLI1_complex_step_jacobian(@(yi) errorfun(xi,yi,X,Y),yi',nX);

    % create the absolute maximum error constraint
    A = [Jyi;-Jyi];
    b = [-errorfun(xi,yi,X,Y) + tol,errorfun(xi,yi,X,Y) + tol]';

    % simple bounds
    lb = repelem(-2*tol,length(yi),1); % allowable lower bound
    ub = repelem(2*tol,length(yi),1); % allowable upper bound

    % quadprog options
    options = optimoptions('quadprog','Display','none','TolFun',1e-12,...
        'TolX',1e-8,'MaxIter',150);

    % display start of QP problem solving
    if opts.display_flag
        disp('   Solving QP to minimize SE...')
    end

    % solve the quadratic program
    dyi = quadprog(H,f,A,b,[],[],lb,ub,[],options);

    % new y values
    yi = yi + dyi(:)';

    % compute new maximum error
    maxerror = max(abs(errorfun(xi,yi,X,Y)));

    % check to make sure the maximum error threshold is still satisfied
    if maxerror-tol >= 1e-12
        error('something went wrong. Maximum error threshold not satisfied after QP')
    end

    % display finished and some plots
    if opts.display_flag

        disp('   ...Finished!')

        % plot type 2 in the script
        plotflag = 2; %#ok<NASGU>

        % create the plots
        RLI1_plots

    end
end

end

% parse the varargin options structure
function opts = parse_inputs(opts)

% extract
if isempty(opts)
    opts = [];
else
    opts = opts{1};
end

% optimize interior point during splitting algorithm
if ~isfield(opts,'interior_optflag') % is this field present?
    opts.interior_optflag = true; % on by default
    % opts.interior_optflag = false; % off
end

% QP for reducing MSE post splitting algorithm
if ~isfield(opts,'post_optflag')
    opts.post_optflag = true; % on by default
    % opts.post_optflag = false; % off
end

% display (command window and plots)
if ~isfield(opts,'display_flag') % is this field present?
    opts.display_flag = true; % on by default
    % opts.display_flag = false; % off
end

% fminbnd options
opts.fminbnd = optimset('TolX',1e-3);

end