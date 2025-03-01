%% for the m order polynomial
load 'proj_fit_13.mat'
[X1_grid, X2_grid] = meshgrid(id.X{1, 1}, id.X{2, 1});
x1_flat = X1_grid(:);
x2_flat = X2_grid(:);
y_flat = id.Y(:);

[X1_val_grid, X2_val_grid] = meshgrid(val.X{1, 1}, val.X{2, 1});
x1_val_flat = X1_val_grid(:);
x2_val_flat = X2_val_grid(:);
y_val_flat = val.Y(:);

n = 10;
MSE_train = zeros(1, n);
MSE_value = zeros(1, n);

min_mse = inf;
best_m = 0;
theta_best = [];

for m = 1:n
    R_train = polynomialTerms(x1_flat, x2_flat, m);
    R_val = polynomialTerms(x1_val_flat, x2_val_flat, m);
    
    theta = R_train \ y_flat;
    yhat_train = R_train * theta;
    yhat_val = R_val * theta;
    
    errors_train = y_flat - yhat_train;
    MSE_train(m) = mean(errors_train.^2);
    
    errors_val = y_val_flat - yhat_val;
    MSE_value(m) = mean(errors_val.^2);

    if MSE_value(m) < min_mse
        theta_best = theta;
        min_mse = MSE_value(m);
        best_m = m;
    end
end

R_plot = polynomialTerms(x1_flat, x2_flat, best_m);
yhat_plot = R_plot * theta_best;

ymatrix = reshape(yhat_plot, size(id.Y));

figure;
ax1 = axes;
mesh(ax1, id.X{1, 1}, id.X{2, 1}, id.Y);
colormap(ax1, 'cool');
hold on;
 
ax2 = axes;
mesh(ax2, id.X{1, 1}, id.X{2, 1}, ymatrix);
colormap(ax2, 'hot');
 
set(ax2, 'Color', 'none');
set(ax2, 'XAxisLocation', 'top', 'YAxisLocation', 'right');
linkprop([ax1, ax2], {'XLim', 'YLim', 'ZLim', 'View'});
view(3);

figure
plot(1:n, MSE_value, 'blue'); grid
hold on
plot(1:n, MSE_train, 'red');
legend('MSE for validation','MSE for training');
plot(4,393,'rs','Marker','*');
text(4,380,'MSE_{min}','Color','k','FontSize',15);

min_mse = min(MSE_value);
disp(min_mse)

function R = polynomialTerms(x1, x2, m)
    terms = [];
    for total_degree = 0:m
        for i = 0:total_degree
            j = total_degree - i;
            term = (x1.^i) .* (x2.^j);
            terms = [terms, term];
        end
    end
    R = terms;
end