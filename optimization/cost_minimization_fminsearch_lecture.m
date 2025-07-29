
%% Lecture: Using fminsearch in MATLAB for Cost Minimization
% This live script walks through a real-world optimization problem and shows
% how to solve it both analytically (using calculus) and numerically (using fminsearch).

%% Problem Setup
% We are designing a cylindrical can that must hold 1000 cm^3 (1 liter) and minimize material cost.
% The side of the can costs $0.02/cm^2, and the top and bottom cost $0.05/cm^2.

%% Step 1: Define Volume Constraint
% Volume of a cylinder: V = pi * r^2 * h = 1000 cm^3
% Solving for h in terms of r:
syms r h
V = pi * r^2 * h;
solve(V == 1000, h)

%% Step 2: Cost Function
% Side area: A_side = 2*pi*r*h
% Top+Bottom area: A_topbottom = 2*pi*r^2
% Cost = 0.02*(side) + 0.05*(top+bottom) = 0.04*pi*r*h + 0.10*pi*r^2

% Substitute h:
% h = 1000 / (pi*r^2)
% So cost as function of r:
% Cost(r) = (40 / r) + 0.10 * pi * r^2

%% Step 3: Visualize Cost vs Radius
r_vals = linspace(1, 10, 200);
cost_vals = (40 ./ r_vals) + 0.10 * pi * r_vals.^2;

figure;
plot(r_vals, cost_vals, 'LineWidth', 2);
xlabel('Radius (cm)');
ylabel('Cost ($)');
title('Cost of Cylindrical Can vs Radius');
set(gcf,'color','W')
grid on;
hold on;
opt_r_analytic = (200/pi)^(1/3);
xline(opt_r_analytic, '--r', 'Analytic Minimum');
legend('Cost(r)', 'Analytic r');

%% Step 4: Solve Using Calculus
% Derivative of Cost(r) = -40/r^2 + 0.20*pi*r
% Set to zero and solve for r
syms r
cost_r = (40 / r) + 0.10 * pi * r^2;
d_cost = diff(cost_r, r);
solve(d_cost == 0, r)

% Compute h from r
r_opt = double((200/pi)^(1/3));
h_opt = 1000 / (pi * r_opt^2);

fprintf('Analytical Solution:\n');
fprintf('  Optimal radius: %.2f cm\n', r_opt);
fprintf('  Optimal height: %.2f cm\n', h_opt);
fprintf('  Minimum cost: %.2f $\n', double(subs(cost_r, r, r_opt)));

%% Step 5: Numerical Optimization Using fminsearch
costFunc = @(r) (40 ./ r) + 0.10 * pi * r.^2;
r0 = 100000;  % initial guess

tic
[optR, minCost] = fminsearch(costFunc, r0);
toc

optH = 1000 / (pi * optR^2);

fprintf('\nNumerical Solution (fminsearch):\n');
fprintf('  Optimal radius: %.2f cm\n', optR);
fprintf('  Optimal height: %.2f cm\n', optH);
fprintf('  Minimum cost: %.2f $\n', minCost);

%% Step 5 (Alternative): Numerical Optimization Using patternsearch
% Requires Global Optimization Toolbox

costFunc = @(r) (40 ./ r) + 0.10 * pi * r.^2;

% Bounds: radius must be positive and realistic
lb = 0.1;  % lower bound
ub = 200000000;   % upper bound
r0 = 1000000;    % initial guess

% Run patternsearch
opts = optimoptions('patternsearch', 'Display', 'iter'); % 'iter' to show output
[optR_ps, minCost_ps] = patternsearch(costFunc, r0, [], [], [], [], lb, ub, [], opts);

% Calculate height using volume constraint
optH_ps = 1000 / (pi * optR_ps^2);

fprintf('\n\nNumerical Solution (patternsearch):\n\n');
fprintf('  Optimal radius: %.2f cm\\n', optR_ps);
fprintf('  Optimal height: %.2f cm\\n', optH_ps);
fprintf('  Minimum cost: %.2f $\n', minCost_ps);