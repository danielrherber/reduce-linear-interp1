%--------------------------------------------------------------------------
% RLI1_examples.m
% This runs through a number of examples demonstrating the usage of the
% function reduce_linear_interp1. Please see the documentation for
% reduce_linear_interp1 for more detail on the inputs. This script has
% also been published.
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
close all; clear; clc; rng(7312947)

%% Example 1.1 - from MC submission 35194
X = 0:0.1:10;
Y = 1./(X/100 + 0.01) + X.^2 - 0.1 * X.^3;

tol = 0.1;
opts.interior_optflag = true; % this is the default
opts.post_optflag = true; % this is the default
opts.display_flag = true; % this is the default

[xi, yi] = reduce_linear_interp1(X,Y,tol,opts); %#ok<ASGLU>

% only uncomment if you have MC submission 35194 in your path
% [xi35194, yi35194, mse35194] = find_best_table_1de(X, Y, [], tol, 'linear');

%% Example 1.2 - from MC submission 35194 with lower tolerance and more points
X = 0:0.0001:10;
Y = 1./(X/100 + 0.01) + X.^2 - 0.1 * X.^3;

% use default options
[xi, yi] = reduce_linear_interp1(X,Y,0.01); %#ok<ASGLU>

%% Example 2.1 - gaussian pdf with randomly spaced points
X = cumsum(rand(1000,1));
X = 200*X/max(X);
f1 = @(x,m,s) exp(-(x-m).^2/(2*s^2))/(s*sqrt(2*pi));
Y = f1(X,100,5) + f1(X,120,3) - f1(X,30,2);

tol = 0.02*(max(Y)-min(Y)); % 2% maximum error
[xi, yi] = reduce_linear_interp1(X,Y,tol); %#ok<ASGLU>

%% Example 2.2 - gaussian pdf with randomly spaced points and random noise
X = cumsum(rand(1000,1));
X = 200*X/max(X);
f1 = @(x,m,s) exp(-(x-m).^2/(2*s^2))/(s*sqrt(2*pi));
Y = f1(X,100,5) + f1(X,120,3) - f1(X,30,2) + rand(size(X))/200;

tol = 0.02*(max(Y)-min(Y)); % 2% maximum error
[xi, yi] = reduce_linear_interp1(X,Y,tol); %#ok<ASGLU>

%% Example 3.1 - digital sine wave with noise
X = linspace(0,8,1000)';
F = round(15*sin(X));
Y = F + round(0.55*rand(size(X))) - round(0.55*rand(size(X))) ;

tol = 2;
[xi, yi] = reduce_linear_interp1(X,Y,tol); %#ok<ASGLU>

%% Example 3.2 - sine wave with normal random noise
X = linspace(0,8,1e6)';
F = 15*sin(X);
Y = F + randn(size(F))/2;

tol = 2.5;
opts.post_optflag = 0; % QP takes is large with 1e6 points

[xi, yi] = reduce_linear_interp1(X,Y,tol,opts);

% only uncomment if you have MC submission 35194 in your path
% warning this will take a long time!!
% [xi35194, yi35194, mse35194] = find_best_table_1de(X, Y, [], tol, 'linear');