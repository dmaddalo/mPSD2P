function plotkomega(X,Y,SS,varargin)

% PLOTKOMEGA Plot the k-omega dispersion diagram.
%  
%   PLOTKOMEGA(X,Y,SS) plots the k-omega diagram SS from the 
%       2D coordinates matrices X and Y.
%   
%   PLOTKOMEGA(...,'PropertyName','PropertyValue') allows to specify
%       additional options to adjust the plot.
%   
%   
%   INPUTS
%    
%   * X: 2D x-coordinate matrix of frequencies.
%   * Y: 2D y-coordinate matrix of wavenumbers.
%   * SS: 2D matrix of the k-omega dispersion diagram.
%   
%
%   SUPPORTED OPTIONS
%
%   'caxis' - Adjusts the colorbar limits.
%   Formatted as: [lowerlimit upperlimit]
%   Default value: [1e-8 1]
%
%   'axis' - Adjusts the axis limits.
%   Formatted as: [xlower xupper ylower yupper]
%   Default value: limits of X and Y vectors as the inputs
% 
%   'cmap' - Adjusts the colormap.
%   Formatted as: jet; jet(1000); copper; ...
%   Default value: jet(1000)
%
%   'cbartitle' - Adjusts the colorbar title.
%   Formatted as: 'a.u.'; 'Power'; ...
%   Default value: 'a.u'
% 
%   'cbarscale' - Adjusts the colorbar scale.
%   Formatted as: 'log'; 'linear';
%   Default value: 'log'
% 
%   'xlabel' - Adjusts the label of the x-axis.
%   Formatted as: '-k_θ [non-dim]'; '-k_z [rad/m]'; ...
%   Default value: '-k_θ [non-dim]'
% 
%   'ylabel' - Adjusts the label of the y-axis.
%   Formatted as: 'f [Hz]'; '\omega [rad/s]; ...
%   Default value: 'f [Hz]'
%
%   'psizearg' - Adjusts the size of the visualized points.
%   Formatted as: [48 4]; [24 2]; ...
%   Default value: [1 1]


% 'caxis' default value
caxisarg = [1e-8 1];
% 'axis' default value
axisarg = [X(1,1) X(1,end) Y(1,1) Y(end,1)];
% 'xlim' default value
xlimarg = [X(1,1) X(1,end)];
% 'ylim' default value
ylimarg = [Y(1,1) Y(end,1)];
% 'cmap' default value
cmaparg = jet(1000);
% 'cbartitle' default value
cbartitlearg = 'a.u.';
% 'cbarcolorscale' default value
cbarscalearg = 'log';
% 'xtitle' default value
xlabelarg = '$k_\theta$ [rad/m]';
% 'ytitle' default value
ylabelarg = '$\omega$ [Hz]';
% 'psizearg' default value
psizearg = [1 1];

%% Alternative map with blank background; incomplete
% % 'cmapalt' default value
% cmapaltarg = false;
%%

flagaxis = false;
if nargin > 3
    ii = 1;
    while ii+3 <= nargin
        % Flag variable for throwing error if no option matches with one of
        % the names provided
        flagerror = true;
        
        % Assign current option name
        currentoptionname = varargin{1,ii};
        % Assign current option value
        currentoptionvalue = varargin{1,ii+1};
        
        % Check for option 'caxis'
        if strcmp(currentoptionname,'caxis') == true
            caxisarg = currentoptionvalue;
            flagerror = false;
            
        % Check for option 'axis'
        elseif strcmp(currentoptionname,'axis') == true
            axisarg = currentoptionvalue;
            flagerror = false;
            
            flagaxis = true;
              
        % The script enters the two following ifs regardless if the options 
        % 'xlim'/'ylim' are defined before 'axis'; however, by doing so, 
        % the values previously set by 'xlim'/'ylim' are overwritten.
        % If the options 'xlim'/'ylim' are defined later than 'axis'
        % instead, these two ifs cannot be performed.
        
        % Check for option 'xlim'
        elseif strcmp(currentoptionname,'xlim') == true && flagaxis == false
            xlimarg = currentoptionvalue;
            flagerror = false;

        % Check for option 'ylim'
        elseif strcmp(currentoptionname,'ylim') == true && flagaxis == false
            ylimarg = currentoptionvalue;
            flagerror = false;
            
        % Check for option 'cmap'
        elseif strcmp(currentoptionname,'cmap') == true
            cmaparg = currentoptionvalue;
            flagerror = false;
                    
        % Check for option 'cbartitle'
        elseif strcmp(currentoptionname,'cbartitle') == true
            cbartitlearg = currentoptionvalue;
            flagerror = false;
            
        % Check for option 'cbarscale'
        elseif strcmp(currentoptionname,'cbarscale') == true
            cbarscalearg = currentoptionvalue;
            flagerror = false;
            
        % Check for option 'xlabel'
        elseif strcmp(currentoptionname,'xlabel') == true
            xlabelarg = currentoptionvalue;
            flagerror = false;
        
        % Check for option 'xlabel'
        elseif strcmp(currentoptionname,'ylabel') == true
            ylabelarg = currentoptionvalue;
            flagerror = false;
            
        % Check for option 'psizearg'
        elseif strcmp(currentoptionname,'psize') == true
            psizearg = currentoptionvalue;
            flagerror = false;
            
%%         % Alternative map with blank background; incomplete
%         % Check for option 'cmapalt'
%         % Write 'alt' within the function options to use blank background
%         elseif strcmp(currentoptionname,'cmapalt') == true
%             cmaparg = [[1,1,1],cmaparg];
%             flagerror = false;

        end  
        
        % Increases while counter to next option name
        ii = ii + 2;
        
        % Displays error message if option name is not found
        if flagerror == true
            error(['Undefined option name ',currentoptionname]);
        end
    end
    
    if flagaxis == false
        axisarg = [xlimarg ylimarg];
    end
end

% Average the bins, if requested
SS = conv2(SS,ones(ceil(psizearg(1)),psizearg(2)),'same')./...
    conv2(ones(size(SS)),ones(ceil(psizearg(1)),psizearg(2)),'same');

surf(X,Y,SS,'linestyle','none'); view(2)
colormap(cmaparg); axis(axisarg); caxis(caxisarg); colorbar;
aa = gca; aa.Colorbar.Title.String = cbartitlearg; aa.ColorScale = cbarscalearg;
aa.XLabel.String = xlabelarg; aa.YLabel.String = ylabelarg;