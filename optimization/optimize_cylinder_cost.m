function [r_opt, h_opt, min_cost] = optimize_cylinder_cost(method, costSide, costEnds)

% Example run: [r_opt, h_opt, min_cost] = optimize_cylinder_cost('fminsearch', 0.04, 0.1)

%OPTIMIZE_CYLINDER_COST Optimize cost of a cylindrical can design
%   [r_opt, h_opt, min_cost] = optimize_cylinder_cost(method)
%   method: 'analytic', 'fminsearch', or 'patternsearch'

    if nargin < 1
        method = 'analytic'; 
    end

    % Cost function in terms of radius

    costFunc = @(r, costSide, costEnds) costSide*(1000 / r) + costEnds*pi*r^2;
%    0.04*pi*(1000/(pi*r ))+0.10*pi*r^2

    
%    costFunc = @(r) (40 ./ r) + 0.1 * pi * r.^2;

    switch lower(method)
        case 'analytic'
            % Analytical solution using calculus
            r_opt = (200 / pi)^(1/3);
            h_opt = 1000 / (pi * r_opt^2);
            min_cost = costFunc(r_opt);

        case 'fminsearch'
            r0 = 1; % reasonable initial guess
            options = optimset('Display','off');
            [r_opt, min_cost] = fminsearch(costFunc, r0, options, costSide, costEnds);
            h_opt = 1000 / (pi * r_opt^2);

        case 'patternsearch'
            if ~license('test', 'GADS_Toolbox')
                error('patternsearch requires the Global Optimization Toolbox.');
            end
            r0 = 1;
            lb = 0.01;
            ub = 1e6;
            opts = optimoptions('patternsearch','Display','off');
            [r_opt, min_cost] = patternsearch(costFunc, r0, [], [], [], [], lb, ub, [], opts);
            h_opt = 1000 / (pi * r_opt^2);

        otherwise
            error('Unknown method. Choose ''analytic'', ''fminsearch'', or ''patternsearch''.');
    end

    % Print results
    fprintf('\nSolution using %s method:\n', method);
    fprintf('  Optimal radius: %.4f cm\n', r_opt);
    fprintf('  Optimal height: %.4f cm\n', h_opt);
    fprintf('  Minimum cost: %.4f $\n', min_cost);
end
