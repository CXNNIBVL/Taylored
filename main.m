close all;
clear;
clc;

syms x;

% ==== Parameters =====
X_VIEWDIFF_EXPANSION_POINT = 10;
Y_VIEWDIFF_EXPANSION_POINT = 4;
DEGREE = 15;
F(x) = x^5 + 2*x^2 - 4*x;
EXPANSION_POINT = 1;
SLEEP_DURATION_SECONDS = 0;
SHOW_TAYLER_POLY = 0;
SHOW_DIVERGENCE = 1;
DIVERGENCE_SAMPLES = 75;
% ==== End Parameters =====

% Setup figure
figure;
set(gcf, 'Position',  [100, 100, 1280, 720]);
xmin = EXPANSION_POINT - X_VIEWDIFF_EXPANSION_POINT;
xmax = EXPANSION_POINT + X_VIEWDIFF_EXPANSION_POINT;
ymin = double(F(EXPANSION_POINT)) - Y_VIEWDIFF_EXPANSION_POINT;
ymax = double(F(EXPANSION_POINT)) + Y_VIEWDIFF_EXPANSION_POINT;
xlims = [xmin xmax];
ylims = [ymin ymax];
xlim(xlims);
ylim(ylims);
xlabel("x", FontWeight="bold");
ylabel("y", FontWeight="bold");
grid on;
hold on;

% Set initial values
tpoly(x) = 0*x;
a = EXPANSION_POINT;
df(x) = F(x);

for k = 0:DEGREE
    
    cla; 
    
    % Derive Taylor polynomial at degree 'k'
    tpoly(x) = tpoly(x) + (df(a) * (x - a)^k) / factorial(k);
    
    % Plot 'em
    fplot(F, xlims, "b");
    fplot(tpoly, xlims, "m--");
    
    % Plot Divergence between 'F' and the current polynomial
    if SHOW_DIVERGENCE
        x_vals = linspace(xmin, xmax, DIVERGENCE_SAMPLES);
        yF = double(F(x_vals));
        ytpoly = double(tpoly(x_vals));
        
        for i = 1:length(x_vals)
            
            ymin_Ft = min(yF(i), ytpoly(i));
            ymax_Ft = max(yF(i), ytpoly(i));

            dotsize = 3;
            
            distance = ymax_Ft - ymin_Ft;
            step = 0.2;

            ydots_i = ymin_Ft:step:ymax_Ft;
            xdots_i = repelem([x_vals(i)], length(ydots_i));
            scatter(xdots_i,ydots_i,dotsize, "red", "filled");

        end
    end
    
    % Prepare Title according to current Taylor degree
    title_taylor_state = ['T' num2str(k) '(' char(F(x)) ', x, ' num2str(EXPANSION_POINT) ')'];
    title_poly_state = [];
    
    % Might just show the Polynomial as well
    if SHOW_TAYLER_POLY
        title_poly_state = [ newline '= ' char(tpoly) ];
    end
    
    % Set Title and Legend
    title_str = strcat(title_taylor_state, title_poly_state);
    title(title_str);
    legend("f", "Taylor Approx.");
    
    % Differentiate for next polynomial
    df(x) = diff(df, x, 1);
    
    pause(SLEEP_DURATION_SECONDS);
end


hold off;