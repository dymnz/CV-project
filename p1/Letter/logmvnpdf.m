function logP = logmvnpdf(x, mu, sigma)
% Get the log MVNPDF
% Source: https://www.mathworks.com/matlabcentral/fileexchange/34064-log-multivariate-normal-distribution-function
    [N,D] = size(x);
    
    subMean = bsxfun(@minus,x,mu);
    logDet = logdet(sigma);
    
    % A/B = A*inv(B) 
    expTerm =  -0.5 * sum((subMean / sigma) .* subMean, 2);
    normTerm = -0.5 * D * log(2*pi) - 0.5*logDet;
    
    logP = expTerm.' + normTerm;
end


function y = logdet(A)

U = chol(A);
y = 2*sum(log(diag(U)));

end