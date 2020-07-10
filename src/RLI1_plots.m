%--------------------------------------------------------------------------
% RLI1_plots.m
% If display flag is 1 or 2, then show some diagnostics and plots
%--------------------------------------------------------------------------
% This is a script
%--------------------------------------------------------------------------
% Primary contributor: Daniel R. Herber (danielrherber on GitHub)
% Link: https://github.com/danielrherber/reduce-linear-interp1
%--------------------------------------------------------------------------
if plotflag == 1

    e = Y - interp1(xi, yi, X, 'linear');
    mse = mean(e.^2);
    disp(['Reduced Length: ',int2str(length(xi))])
    disp(['with maximum absolute error of ',num2str(max(abs(e)))])
    disp(['Percentage of original size: ', num2str(length(xi)/length(X)*100),'%'])
    disp(['Mean Squared Error: ',num2str(mse)])

    if opts.post_optflag == 0 % if the post optimization isn't happening

        % original data with reduced data set
        hf = figure; hold on; hf.Color = 'w';
        plot(X,Y,'o','markeredgecolor',[0.9290,0.6940,0.1250]);
        plot(xi,yi,'linewidth',2,'color',[0,0.4470,0.7410]);
        legend('original data','reduced data');
        xlabel('X'); ylabel('Y');

        % bar chart of errors
        hf = figure; hold on; hf.Color = 'w';
        plot(tol*ones(size(e)),'--k');
        plot(-tol*ones(size(e)),'--k');
        bar(e,'linewidth',0.5,'facecolor',[0,0.4470,0.7410],...
            'edgecolor','none');
        legend('tolerance','tolerance','error','location','best');
        xlabel('X index'); ylabel('error');
        xlim([0 length(X)+1]); ylim([-1.05*tol 1.05*tol]);

        % log10 of the step size
        hf = figure; hold on; hf.Color = 'w';
        stairs(log10(diff(xi)),'linewidth',2);
        xlabel('X index'); ylabel('log_{10} of the Step Size');

    else
        xi1 = xi; yi1 = yi; e1 = e; % save for later
    end

elseif plotflag == 2

    mseold = mse;
    e = Y - interp1(xi, yi, X, 'linear');
    mse = mean(e.^2);
    disp(['Percentage of Original Mean Squared Error : ',num2str(mse/mseold*100),'%'])
    disp(['with maximum absolute error of ',num2str(max(abs(e)))])

    % original data with reduced data sets
    hf = figure; hold on; hf.Color = 'w';
    plot(X,Y,'o','markeredgecolor',[0.9290,0.6940,0.1250]);
    plot(xi1,yi1,'linewidth',2,'color',[0,0.4470,0.7410]);
    plot(xi,yi,'linewidth',2,'color',[0.8500,0.3250,0.0980]);
    xlabel('X'); ylabel('Y');
    legend('original','reduced','reduced after QP','location','best');

    % bar chart of errors
    hf = figure; hold on; hf.Color = 'w';
    plot(tol*ones(size(e)),'--k');
    plot(-tol*ones(size(e)),'--k');
    bar(e1,'linewidth',0.5,'facecolor',[0,0.4470,0.7410],...
        'edgecolor','none');
    bar(e,'linewidth',0.5,'facecolor',[0.8500,0.3250,0.0980],...
    'edgecolor','none');
    legend('tolerance','tolerance','error','error after QP',...
    'location','best');
    xlabel('X index'); ylabel('error');
    xlim([0 length(X)+1]); ylim([-1.05*tol 1.05*tol]);

    % log10 of the step size
    hf = figure; hold on; hf.Color = 'w';
    stairs(log10(diff(xi)),'linewidth',2);
    xlabel('X index'); ylabel('log_{10} of the Step Size');

end