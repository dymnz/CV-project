
K = MAX_CLASS;
errorCount = zeros(size(TestSet));

for i = 1 : K
    target = i;	% The target of this subset
        
    for r = 1 : size(TestSet{i}, 1)
        xi = TestSet{i}(r, :).';	% The samples of this subset
        yi = dualSoftmax(TrainSet, psi, xi);  
        [val ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end

disp(sprintf('TestSet correct: %.2f%%', ...
    (1-sum(errorCount)/sum(TestCount)) * 100));
