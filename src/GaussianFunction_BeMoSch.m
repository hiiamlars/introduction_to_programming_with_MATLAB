function y = GaussianFunction_BeMoSch(x, m, s)
% Berechnet den Wert der Guass'schen Glockenkurve
% Defaults für s oder m und s, wenn keine entsprechenden Argumente
% x als Skalar oder Vektor

    switch nargin

        case 1

            m = 0; % Default für m (Mittelwert)
            s = 1; % Default für s (Standardabweichung)
    
        case 2

            s = 1; % Default für s (Standardabweichung)
    
        case 3

            % keine Defaults notwendig

        otherwise

            error('Falsche Anzahl an Argumenten: Erwartet werden 1, 2 oder 3')

    end

    % Berechnung der Konstante
    const = 1 / (sqrt(2 * pi));

    % Berechnung des Exponenten (Elementweise)
    exponent = -0.5 * ((x - m) / s).^2;

    % Berechnung der Werte der Guass'schen Glockenkurve
    y = const / s * exp(exponent);

end