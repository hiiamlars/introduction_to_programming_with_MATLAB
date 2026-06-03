function [ out ] = ShowExperimentalData_MoSch(myFileName, myDataDirectory)
%% ---Help Function---

% Last edited: Lars, 14.11.2025 21:45

% This function loads experimental data from a MAT-file and plots
% the performance of all participants (observers) as a function
% of experimental conditions.
%
% The MAT-file must contain a structure with fields:
%   VPn     : cell array or string array of participant names
%   xWerte  : matrix of X-values (conditions) [participants x conditions]
%   yWerte  : matrix of Y-values (measurements) [participants x conditions]
%
% Syntax:
%   out = ShowExperimentalData_MoSch(myFileName, myDataDirectory)
%
% Inputs:
%   myFileName      - Name of the MAT-file (string or char)
%   myDataDirectory - Directory containing the MAT-file (string or char)
%
% Outputs:
%   out - logical, true if execution was successful
%
% If zero or only one input is given, a file-selection dialog is opened.
% The function automatically checks that the directory and file exist.
%
% The resulting plot shows each participant with:
% - distinct color
% - distinct marker
% - participant name displayed next to their line
%
% Example:
%   out = ShowExperimentalData_MoSch('experimentalData.mat','C:\Data')
%


%% ---Defined Variables---

CURRENT_FUNCTION_NAME = 'ShowExperimentalData_MoSch';
BASE_MARKERS = {'o','s','d','^','v','>','<','p','h','+'};  % for plot points
AMOUNT_ROWS = 1; % for (sufficient) marker creation
LINE_WIDTH = 1.5; % for plot lines
FONT_SIZE = 10; % for line labels
MARGIN = 0.02; % for line labels
PLOT_TITLE = 'Experimental Data of All Observers';
Y_LABEL = 'Performance Score';
X_LABEL = 'Time';

%% ---Check Argument Amount---

if nargin < 2 % In case of less than two arguments ...
    [myFileName, myDataDirectory] = uigetfile('*.mat', 'Select data file'); % ... open uigetfile
    if isequal(myFileName, 0) % In case of abortion ...
        error([CURRENT_FUNCTION_NAME ':UserCancelled'], ...
            'Data selection was aborted.'); % ... print this message
    end
elseif nargin > 2 % Else in case of more than two arguments ...
    error([CURRENT_FUNCTION_NAME ':TooManyInputs'], ...
        'The function expects a maximum of two inputs (myFileName, myDataDirectory).'); % ... print this message
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

%% ---Check Directory Existence---

if ~isfolder(myDataDirectory) % If 'myDataDirectory' is NOT a folder ...
    error([CURRENT_FUNCTION_NAME ':DirectoryNotFound'], ... % ... print this message
        'The directory does not exist: %s', myDataDirectory);
end

%% ---Check File Existence---

fullPath = fullfile(myDataDirectory, myFileName); % create the 'fullPath' to the data

if ~isfile(fullPath) % If the 'fullPath' is not accesible ...
    error([CURRENT_FUNCTION_NAME ':FileNotFound'], ... % print this message
        'File not found: %s', fullPath);
end

%% ---Load Dataset---
data = load(fullPath); % load data

dataNames = string(data.VPn); % extract participants names and format to string
dataX = data.xWerte; % extract x-values
dataY = data.yWerte; % extract y-values 

%% ---Plotting---
figure; hold on; grid on;

% Set aesthetics
colors  = lines(length(dataNames)); % creates a RGB-matrix of n distinct colors
markers = repmat(BASE_MARKERS, AMOUNT_ROWS, ....
    ceil(length(dataNames)/length(BASE_MARKERS))); % creates n (not completly distinct) markers
markersTrimmed = markers(1:length(dataNames)); % trimms to the nessecary amount of markers

% Plot each observer separately
for i = 1:length(dataNames) % iterates over each participant
    plot(dataX(i, :), dataY(i,:), ... % plots all values of the i'th row in y
        'Color', colors(i,:), ... % distinct RGB-color for each participant
        'Marker', markersTrimmed{i}, ... % distinct marker for each participant
        'LineWidth', LINE_WIDTH); % constant linewidth

    % Add participant name next to last data point ...
    text(dataX(i,end) ... % at the last x-value ...
        + MARGIN*(max(dataX(i,:))-min(dataX(i,:))),... % with a small horizontal offset ...
        dataY(i,end), dataNames(i), ... % at the last y-value ...
        'FontSize', FONT_SIZE, 'Color', colors(i,:)); % with respective asthetics

end

xlabel(X_LABEL); % Description for x-axis
ylabel(Y_LABEL); % Description for y-axis
title(PLOT_TITLE); % Plot title

hold off;

%% ---Output---
out = true;