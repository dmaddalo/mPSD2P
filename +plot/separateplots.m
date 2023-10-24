function separateplots(stats,Kcsd,Fcsd,SScsd,params)
    addpath('../matlab-figures/src')
    
    % Lower and upper std limits
    lowstd_az = stats.az.meanphase - stats.az.stdphase;
    uppstd_az = stats.az.meanphase + stats.az.stdphase;
    lowstd_ax = stats.ax.meanphase - stats.ax.stdphase;
    uppstd_ax = stats.ax.meanphase + stats.ax.stdphase;
    lowstd_rd = stats.rd.meanphase - stats.rd.stdphase;
    uppstd_rd = stats.rd.meanphase + stats.rd.stdphase;
    
    %% Azimuthal
    % Dispersion diagram
    %--------------------------------------------------------------------------
    figure
    defaults.default_properties_axes;
    plot.plotkomega(Kcsd.az/0.01,Fcsd.az,SScsd.az,'caxis',[1e-12 1e-4],'cbartitle','PW');
    hold on;
    % Std scatterplot
    scatter(lowstd_az/0.01,stats.az.fRFTbin,4,'r','filled')
    scatter(uppstd_az/0.01,stats.az.fRFTbin,4,'r','filled')
    %--------------------------------------------------------------------------
    title(['Azimuthal dispersion; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega']);
    cc = get(gcf,'Children');
    defaults.default_properties_colorbar(cc(1));
    %--------------------------------------------------------------------------
    % m mode lines
    if params.y ~= 0
        for i = -10:10
           xline(i/params.y/1e-3,'color','w','LineStyle',':') 
        end
    end
    %--------------------------------------------------------------------------
    
    % Cross-power spectrum
    figure
    defaults.default_properties_axes;
    plot(stats.az.fRFTbin,10.^(stats.az.meanpow))
    set(gca,'YScale','log');
    hold on;
    % Std lines
    plot(stats.az.fRFTbin,10.^(stats.az.meanpow - stats.az.stdpow),'color','r');
    plot(stats.az.fRFTbin,10.^(stats.az.meanpow + stats.az.stdpow),'color','r');
    %--------------------------------------------------------------------------
    title(['Azimuthal cross-power spectrum; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    xlabel('$\omega$ [Hz]')
    ylabel('$P_{32}$ [V$^2$ s$^{-1}$]')
    %--------------------------------------------------------------------------
    % Set axis
    
    % ////
    
    %% Axial
    % Dispersion diagram
    %--------------------------------------------------------------------------
    figure
    defaults.default_properties_axes;
    plot.plotkomega(Kcsd.ax/0.01,Fcsd.ax,SScsd.ax,'caxis',[1e-12 1e-4],'cbartitle','PW','xlabel','$k_z$ [rad/m]');
    hold on
    % Std scatterplot
    scatter(lowstd_ax/0.01,stats.ax.fRFTbin,4,'r','filled')
    scatter(uppstd_ax/0.01,stats.ax.fRFTbin,4,'r','filled')
    %--------------------------------------------------------------------------
    title(['Axial dispersion; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    cc = get(gcf,'Children');
    defaults.default_properties_colorbar(cc(1));
    %--------------------------------------------------------------------------
    
    % Cross-power spectrum
    figure
    defaults.default_properties_axes;
    plot(stats.ax.fRFTbin,10.^(stats.ax.meanpow))
    set(gca,'YScale','log');
    hold on;
    % Std lines
    plot(stats.ax.fRFTbin,10.^(stats.ax.meanpow - stats.ax.stdpow),'color','r');
    plot(stats.ax.fRFTbin,10.^(stats.ax.meanpow + stats.ax.stdpow),'color','r');
    %----------------------------------------------------------------------
    title(['Axial cross-power spectrum; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    xlabel('$\omega$ [Hz]')
    ylabel('$P_{24}$ [V$^2$ s$^{-1}$]')
    %--------------------------------------------------------------------------
    % Set axis
    
    % ////
    
    %% Radial
    % Dispersion diagram
    %--------------------------------------------------------------------------
    figure
    defaults.default_properties_axes;
    plot.plotkomega(Kcsd.rd/0.01,Fcsd.rd,SScsd.rd,'caxis',[1e-12 1e-4],'cbartitle','PW','xlabel','$k_r$ [rad/m]');
    hold on
    % Std scatterplot
    scatter(lowstd_rd/0.01,stats.rd.fRFTbin,4,'r','filled')
    scatter(uppstd_rd/0.01,stats.rd.fRFTbin,4,'r','filled')
    %--------------------------------------------------------------------------
    title(['Radial dispersion; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    cc = get(gcf,'Children');
    defaults.default_properties_colorbar(cc(1));
    %--------------------------------------------------------------------------
    
    % Cross-power spectrum
    figure
    defaults.default_properties_axes;
    plot(stats.rd.fRFTbin,10.^(stats.rd.meanpow))
    set(gca,'YScale','log');
    hold on;
    % Std lines
    plot(stats.rd.fRFTbin,10.^(stats.rd.meanpow - stats.rd.stdpow),'color','r');
    plot(stats.rd.fRFTbin,10.^(stats.rd.meanpow + stats.rd.stdpow),'color','r');
    %--------------------------------------------------------------------------
    title(['Radial cross-power spectrum; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    xlabel('$\omega$ [Hz]')
    ylabel('$P_{12}$ [V$^2$ s$^{-1}$]')
    %--------------------------------------------------------------------------
    % Set axis
    
    % ////
    
    %% Coherence
    
    figure
    defaults.default_properties_axes;
    plot(stats.az.fRFTbin,stats.az.coherence)
    ylim([0 1])
    hold on
    plot(stats.ax.fRFTbin,stats.ax.coherence)
    plot(stats.rd.fRFTbin,stats.rd.coherence)
    legend('azimuthal','parallel','radial','Location','best','interpreter','latex')
    title(['Coherence; $\dot{m} = ',num2str(params.mdot), ...
        ', \alpha = ',num2str(params.alpha),', d = ',num2str(params.d), ...
        '$;' newline 'CSD averaged k-omega'])
    xlabel('$\omega$ [Hz]');
    % xticks([0 0.5e5 1e5 1.5e5 2e5])
    % xticklabels(['0','0.5','1e5','1.5e5','2e5'])
    % ylabel('V$^2$ s$^{-1}$');
