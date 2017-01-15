
options = struct('format','html', 'evalCode', false, 'catchError', false);
publish('./findHomography.m', options);
publish('./ImageStitchingBrightnessMathcing.m', options);
publish('./IntensityMatchingMulti.m', options);
publish('./PolynomialInference.m', options);
publish('./PolynomialRegression.m', options);
publish('./Preprocessing.m', options);
publish('./surfFindMatchPoints.m', options);