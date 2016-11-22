
K = MAX_CLASS;
errorCount = zeros(size(TestSet));

for i = 1 : K
    target = i;
    
    for r = 1 : size(TestSet{i}, 1)
        xi = TestSet{i}(r, :).';
        yi = softmax(xi, theta);
        [v ind] = max(yi);
        if ind ~= target
            errorCount(i) = errorCount(i) + 1;
        end
    end
end

disp( (1-sum(errorCount)/sum(TestCount)) * 100);