function [ out ] = AnalyseData_MoSch( myFileName, myDataDirectory ) 
%% ---Help Function--------------------------------------------------------
% AnalyseData_MoSch loads and compares data.
%
% Last edited: Lars, 05.12.2025
%
% This function loads experimental data (A, B, x) from a MAT-file and:
%  - plots the empirical data sets A and B (different colors and markers))
%  - plots the theoretical functions
%         fa(x) = 3*exp(-x) - 1
%         fb(x) = x.^2 - 1
%    using exactly N = 350 (theoretical) x-values
%  - calculates the means and standard deviations of the differences
%        (data - model)
%  - writes these values into the figure
%  - prints these values into the Command Window
%
% Usage:
%   out = AnalyseData_MoSch
%   out = AnalyseData_MoSch('file','path')
%
% Output:
%   out = logical, true if everything executed without errors

%% ---Defined Variables---

% Name of the current function (for debugging and error messages)
CURRENT_FUNCTION_NAME = 'AnalyseData_MoSch';

% Plot settings
COLOR_A        = 'r';      % color for data A and theory A
COLOR_B        = 'b';      % color for data B and theory B
MARKER_A       = 'o';      % marker shape for data A
MARKER_B       = 's';      % marker shape for data B
MARKER_SIZE    = 6;        % marker size
LINE_WIDTH     = 1.5;      % line thickness for theoretical curves

% Theoretical curves settings
N_POINTS = 350;            % amount of simulated x-values
FA = @(z) 3 .* exp(-z) - 1; % fa(x) = 3*exp(-x) - 1 
FB = @(z) z.^2 - 1; % fb(x) = x.^2 - 1

% Figure text settings
PLOT_TITLE     = 'Compare Data'; % plot title
X_LABEL        = 'x'; % x-axis label
Y_LABEL        = 'y'; % y-axis label
TEXT_BG_COLOR  = [0 0 0 0.4];  % semi-transparent black background
TEXT_V_ALIGN   = 'top'; % general alignment of text
TEXT_COLOR     = [1 1 1]; % text color

%% ---Check Argument Amount---

if nargin < 2 % In case of less than two arguments ...
    [myFileName, myDataDirectory] = uigetfile('*.mat', 'Select data file'); % ... open uigetfile
    if isequal(myFileName, 0) % In case of abortion ...
        error([CURRENT_FUNCTION_NAME ':UserCancelled'], ...
            'Data selection was aborted.'); % ... print this message
    end

elseif nargin > 2 % Else in case of more than two arguments (though MATLAB should check this automatically)...
    error([CURRENT_FUNCTION_NAME ':TooManyInputs'], ...
        'The function expects a maximum of two inputs (myFileName, myDataDirectory).'); % ... print this message

elseif nargin == 2 % Else in case of exactly two arguments ...
    % check the existence of the directory and file
    assert(isfolder(myDataDirectory), ...
        ['The specified directory ''' myDataDirectory ''' does not exist.']);
    assert(isfile(fullfile(myDataDirectory, myFileName)), ...
        ['The specified file ' myFileName ' does not exist in the directory ' myDataDirectory '.']);
end

%% ---Check Content---

if ~(ischar(myFileName) || isstring(myFileName)) % If 'myFileName' is NOT formated as character or string ...
    error('ShowExperimentalData_MoSch:InvalidFileName', ... % ... print this message
        'myFileName must be a character vector or string.');
end

if ~(ischar(myDataDirectory) || isstring(myDataDirectory)) % If 'myDataDirectory' is NOT formated as character or string ...
    error('ShowExperimentalData_MoSch:InvalidDataDirectory', ... % ... print this message
        'myDataDirectory must be a character vector or string.');
end

%% ---Load Data--- 

fullPath = fullfile(myDataDirectory, myFileName); % Create the full path ...
data = load(fullPath); % ... and load the data from it

%% ---Check Data---

% optional as we were told the data is formated this way
assert(isfield(data,'A') && isfield(data,'B') && isfield(data,'x'), ...
       'The MAT-file must contain variables A, B and x.');

%% ---Assign Data---

A = data.A;   % empirical data A
B = data.B;   % empirical data B
x = data.x;   % x-values (shared for A and B)

%% ---Models---

% Theoretical curve x-values (350 points)
xTh = linspace(min(x), max(x), N_POINTS);

% Theoretical model curves
yATheory = FA(xTh);
yBTheory = FB(xTh);

% Model values exactly at the data x-positions (for differences)
yAModelAtData = FA(x);
yBModelAtData = FB(x);

%% ---Plotting---

% Create empty figure
figure; hold on; grid on;

% Empirical data (scatter points)
plot(x, A, ...
    'LineStyle', 'none', ...
    'Marker', MARKER_A, ...
    'MarkerSize', MARKER_SIZE, ...
    'Color', COLOR_A, ...
    'DisplayName', 'Data A');

plot(x, B, ...
    'LineStyle', 'none', ...
    'Marker', MARKER_B, ...
    'MarkerSize', MARKER_SIZE, ...
    'Color', COLOR_B, ...
    'DisplayName', 'Data B');

% Theoretical curves (smooth lines)
plot(xTh, yATheory, ...
    'LineStyle', '-', ...
    'LineWidth', LINE_WIDTH, ...
    'Color', COLOR_A, ...
    'DisplayName', 'Theory A');

plot(xTh, yBTheory, ...
    'LineStyle', '-', ...
    'LineWidth', LINE_WIDTH, ...
    'Color', COLOR_B, ...
    'DisplayName', 'Theory B');

% Plot labels and title
xlabel(X_LABEL);
ylabel(Y_LABEL);
title(PLOT_TITLE);

%% ---Compute Statistics---

% Difference between actual value and model
diffA = A - yAModelAtData;
diffB = B - yBModelAtData;

% mean values
meanA = mean(diffA);
meanB = mean(diffB);

% standard deviations
sdA  = std(diffA);
sdB  = std(diffB);

%% ---Display Statistics---

% mean and standard deviations for A

disp('===== Differences A (Data A - Model A) =====');
disp(['Mean Difference A: ', num2str(meanA)]);
disp(['Sd        A: ', num2str(sdA)]);

% empty row for readability
disp(' ');

% mean and standard deviations for B
disp('===== Differences B (Data B - Model B) =====');
disp(['Mean Difference B: ', num2str(meanB)]);
disp(['Sd        B: ', num2str(sdB)]);

%% ---Write Statistics into Figure---

% Compute a the highest y-value within A and B
yMaxAll = max([A(:); B(:)]);

% Create formatted statistics text
statsText = sprintf('A: mean = %.4f, sd = %.4f\nB: mean = %.4f, sd = %.4f', ...
                    meanA, sdA, meanB, sdB);

% Display the text centered and at the top
text(mean(xlim), yMaxAll, statsText, ...
    'VerticalAlignment', TEXT_V_ALIGN, ...
    'HorizontalAlignment','center', ...
    'BackgroundColor', TEXT_BG_COLOR, ...
    'Color', TEXT_COLOR);

hold off;

%% ---Output---

% print true in case the function was executed until this point
out = true;

end