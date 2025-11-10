function result = GaussianFunction_MoSch(myX, myParameters)
% Last change: Lars, 10.11.2025 15:10
% GaussianFunction_MoSch calculates Guass distributed values and plots them
%
%   result = GaussianFunction_MoSch(myX, myParameters)
%
%   myX :           Vector or scalar of the x-value(s)
%   myParameters:   Vector [mu, sigma] with mean (mu) and standard
%   deviation (sigma > 0).
%
% If no output argument is requested (nargout == 0), the plot will be displayed.

%% --- I. Definition of constants ---

DEFAULT_MU = 0.5; % Default mean
DEFAULT_SIGMA = 1.0; % Default standard deviation
CONSTANT_SIGMA = 4; % Amount of maximal standard deviation for the 100 extra values
SMOOTH_POINTS = 100; % Additional values for the plot
PLOT_MARGIN_FACTOR = 0.15; % 15% margin on sides of the plot

% Constant: 1 / sqrt(2*pi) (standardization factor)
CONST_FACTOR = 1 / sqrt(2 * pi); 

%% --- II. Defensive input-checking and parameter assignemnt ---
currentFunctionName = mfilename; % function name for all error-messages or warning-messages

% 1. Check the amount of input arguments...
if nargin < 1
    error([currentFunctionName ':MissingX'], 'Die Funktion benötigt mindestens das Argument myX.');
elseif nargin > 2
    error([currentFunctionName ':TooManyInputs'], 'Die Funktion erwartet maximal 2 Input-Argumente (myX und myParameters).');
end

% ... and set myParameter defaults if they are not included in the input
if nargin == 1
    myParameters = [DEFAULT_MU, DEFAULT_SIGMA];
    warning([currentFunctionName ':DefaultsUsed'], 'myParameters fehlte. Defaults [mu=%.1f, sigma=%.1f] wurden gesetzt.', DEFAULT_MU, DEFAULT_SIGMA);
end

% 2. Check that mxY is not empty...
if isempty(myX)
    error([currentFunctionName ':XEmpty'], 'Argument myX darf nicht leer sein.');
end
% ... and is a numeric vector
validateattributes(myX, {'numeric'}, {'vector'}, mfilename, 'myX', 1);

% 3. Check that myParameters is a numeric vector
validateattributes(myParameters, {'numeric'}, {'vector'}, mfilename, 'myParameters', 2);

% 4. Check that - for the case myParameters was given as an input argument
% - it has the correct amount of entries
assert(length(myParameters) == 2, ...
    [currentFunctionName ':InvalidParamLength'], ...
    'myParameters muss genau 2 Werte ([mu, sigma]) enthalten. Aktuelle Länge: %d', length(myParameters));

% 5. Extract the entries from myParameters...
mu = myParameters(1);
sigma = myParameters(2);

% ... und apply logical checks on them
assert(sigma > 0, [currentFunctionName ':SigmaNotPositive'], 'Die Standardabweichung (sigma) muss positiv sein (>0).');
assert(isfinite(mu) && isfinite(sigma), [currentFunctionName ':NotFinite'], 'mu und sigma müssen endliche Zahlen sein.');

%% --- III. Calculate myX-values ---

% Elementwise calculation (.^) for myX
result = CONST_FACTOR / sigma * exp(-0.5 * ((myX - mu)./sigma).^2);

%% --- IV. Calculate additional values ---

% Calculate "SMOOTH_POINTS" additional x-values with "CONSTANT_SIGMA"
smoothXmin = mu - CONSTANT_SIGMA * sigma;
smoothXmax = mu + CONSTANT_SIGMA * sigma;
smoothXresult = linspace(smoothXmin, smoothXmax, SMOOTH_POINTS);

% Elementwise calculation (.^) for the simulated x-values
smoothYresult = CONST_FACTOR / sigma * exp(-0.5 * ((smoothXresult - mu)./sigma).^2);

%% --- V. Create plot ---

if nargout == 0 % displays the plot only if no output argument is specified

        if isempty(get(0,'CurrentFigure'))
        figure
        end % creates a new blank figure window, if there is not already one open
        % (with "figure;" MATLAB provided an endless number of plots for any myX vector)

    % Plot 1: smooth curve
    plot(smoothXresult, smoothYresult, 'b-'); % smooth curve is displayed as blue line
    hold on; % set to hold the current plot and add everything else on top of it

    % Plot 2: myX curve
    plot(myX, result, 'ro', 'LineStyle', 'none'); % myX values are displayed in red dots

    % calculate margins for the plot
    maximumY = CONST_FACTOR / sigma; % maximum y-value
    marginY = maximumY * PLOT_MARGIN_FACTOR; % y-margin
    rangeX = smoothXmax - smoothXmin; % range of X
    marginX = rangeX * PLOT_MARGIN_FACTOR; % x-margin

    % Set axis with margins on the sides
    xlim([smoothXmin - marginX, smoothXmax + marginX]); % apply x-margin
    ylim([0 - marginY, maximumY + marginY]); %apply y-margin

    hold off; % set back to the default to let go of the current plot and create a new one from here

end
