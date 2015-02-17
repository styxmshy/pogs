function [pogs_time, cvx_time] = lp_eq_sp(m, n, nnz, params)
%LP_EQ

if nargin == 3
  params = [];
end

% Generate data.
rng(0, 'twister')

nnz_ = nnz;
load('tmp.mat');
if ~exist('A', 'var') || size(A, 1) ~= m || size(A, 2) ~= n || nnz ~= nnz_
  fprintf('Generating new matrix...')
  nnz = nnz_;
  A = 4 / n * sprand(m, n, nnz / (m * n));
  b = A * rand(n, 1);
  c = rand(n, 1);
  save('tmp.mat', 'A', 'b', 'c', 'nnz', '-v7.3');
  fprintf(' done!\n')
end

f.h = [kIndEq0(m); kIdentity];
f.b = [b; 0];
g.h = kIndGe0;

% Solve.
tic
x_pogs = pogs([A; c'], f, g, params);
pogs_time = toc;
tic

% cvx_begin
% variables x(n)
% minimize(c' * x)
% subject to
%   b == A * x
%   x >= 0
% cvx_end
% cvx_time = toc;
% 
% (c' * x_pogs - cvx_optval) / (cvx_optval)


end

