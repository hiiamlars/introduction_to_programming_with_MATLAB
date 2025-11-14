function [ out ] = ShowExperimentalData_MoSch(myFileName, myDataDirectory)
%% ---Help Function---

%% ---Defined Variables---
CURRENT_FUNCTION_NAME = 'ShowExperimentalData_MoSch';
%% ---Check Argument Amount---
if nargin < 2
    [myFileName, myDataDirectory] = uigetfile;
    if isequal(myFileName, 0)
        error([CURRENT_FUNCTION_NAME ':UserCancelled'], ...
            'Dateiauswahl wurde abgebrochen.');
    end
elseif nargin > 2
    error([CURRENT_FUNCTION_NAME ':TooManyInputs'], 'Die Funktion erwartet maximal 2 Input-Argumente (myFileName & myDataDirectory).');
end
%% ---Check Content---
if ~(ischar(myFileName) || isstring(myFileName))
    error('ShowExperimentalData_MoSch:InvalidFileName', ...
        'myFileName must be a character vector or string.');
end

if ~(ischar(myDataDirectory) || isstring(myDataDirectory))
    error('ShowExperimentalData_MoSch:InvalidDataDirectory', ...
        'myDataDirectory must be a character vector or string.');
end
%% ---Load Dataset---

if isfile(fullfile(myDataDirectory, myFileName))
    disp('File is in the myDataDirectory');
    data = load(fullfile(myDataDirectory, myFileName));
    disp('File loaded successfully');
else
    error([CURRENT_FUNCTION_NAME ':FileNotFound'], ...
          'Datei nicht gefunden: %s', fullfile(myDataDirectory, myFileName));
end

%% ---Extract Variables---
names = string(data.VPn);
x = data.xWerte;
y = data.yWerte;

%% --- Plot ---
figure; hold on;
plot(x, y, 'o-');
xlabel('X Values');
ylabel('Y Values');
title('Experimental Data Plot');
legend(names);
grid on;
hold off;
out = true; % Indicate successful execution






