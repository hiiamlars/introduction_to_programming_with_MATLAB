function out = GaussianFunction_MoSch(myX, m, s)
% GaussianFunction_MoSch  Einfache Gauß-Funktion mit robusten Input-Checks
%   out = GaussianFunction_MoSch(myX, m, s)
%   - myX : Vektor oder Skalar (1xN oder Nx1)
%   - m   : Mittelwert (Skalar), Default = 0.5
%   - s   : Standardabweichung (Skalar > 0), Default = 1
%
%   Wenn kein Output angefordert wird (nargout==0), wird geplottet.

%% Checks der Formatierung der Eingaben 
switch nargin 
    case 1 
   
if ~isnumeric(myX)
    error('GaussianFunction_MoSch:XNotNumeric', ...
        "Eingabe 'myX' muss numerisch sein.");
elseif ~(isvector(myX) || isscalar(myX))
    error('GaussianFunction_MoSch:XNotVectorOrScalar', ...
        "Eingabe 'myX' muss Skalar oder Vektor sein.");
end
    case 2 

if ~isnumeric(m)
    error('GaussianFunction_MoSch:MNotNumeric', ...
        "Eingabe 'm' muss numerisch sein.");
elseif ~isscalar(m)
    error('GaussianFunction_MoSch:MNotScalar', ...
        "Eingabe 'm' muss ein Skalar sein.");
elseif ~isfinite(m)
    error('GaussianFunction_MoSch:MNotFinite', ...
        "Eingabe 'm' muss endlich sein.");
end
    case 3

if ~isnumeric(s)
    error('GaussianFunction_MoSch:SNotNumeric', ...
        "Eingabe 's' muss numerisch sein.");
elseif ~isscalar(s)
    error('GaussianFunction_MoSch:SNotScalar', ...
        "Eingabe 's' muss ein Skalar sein.");
elseif ~isfinite(s)
    error('GaussianFunction_MoSch:SNotFinite', ...
        "Eingabe 's' muss endlich sein.");
elseif s <= 0
    error('GaussianFunction_MoSch:SNotPositive', ...
        "Eingabe 's' muss positiv sein (>0).");
    
    case > 3
        error('GaussianFunction_MoSch:SNotFinite', ...
        "Eingabe muss 1-3 Werte sein.");

end
end
%% Werte festlegen
mean_default = 0.5;
sd_default = 1;

%% Ensure that the function works even if called with only a single input
% argument, i.e. "GaussianFunction(myX)"
if nargin == 0
    error('Function needs at least one input argument, enter "myX" when calling the function.')
elseif nargin == 1
    m = mean_default;
    s = sd_default;
    warning('Only x supplied. Defaults are set: m = 0.5 and s = 1')
elseif nargin == 2
    s = sd_default; 
    warning('Only supplied x and m. Default set: s = 1')
end

%% Berechnung 
out = (1/(s*sqrt(2*pi))) * exp(-0.5 * ((myX - m)./s).^2);

%% Plot the calculated values -- make the plot look nice

% 100 zufällige, normalverteilte Werte erzeugen
random_values = m + s * randn(100, 1);

% Verknüpfen der Vektoren
plot_values = [random_values; out];  

% Ausgabeplot; 
title('my first MATLAB function')
xlabel('x values')
ylabel('y values')
legend('Gaussian Function')
xlim([min(plot_values)-1, max(plot_values)+1])
ylim([min(plot_values)-1, max(plot_values)+1])


% The MATLAB function "gca" returns a handle to the current axis in the current plot.
% This allows you to manipulate aspects of the plot after it was produced.
set(gca, 'ylim', [min(out)-0.2 max(out)+0.2])

% apply the function nargout
disp(nargout)

end