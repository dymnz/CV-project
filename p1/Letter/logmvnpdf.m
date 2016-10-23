function logP = logmvnpdf(x, mu, cov)
% Get the log MVNPDF
% Source: https://www.mathworks.com/matlabcentral/fileexchange/34064-log-multivariate-normal-distribution-function
    [N,D] = size(x);
    
    subMean = bsxfun(@minus,x,mu);
    
    % A/B = A*inv(B) 
    expTerm =  -0.5 * sum((subMean / cov) .* subMean, 2);
    normTerm = -0.5 * D * log(2*pi) - 0.5*logDet(cov);
    
    logP = expTerm' + normTerm;
end


function y = logDet(A)

U = chol(A);
y = 2*sum(log(diag(U)));

end