
activation = cell(1, LAYER_COUNT);
errorCount = zeros(size(TrainSet));

for i = 1 : MAX_CLASS   
    Target = i;
    for r = 1 : size(TrainSet{i}, 1)	% For each sample    
        
        % Forward propagation
        activation{1} = TrainSet{i}(r, :).';  % Let X be the output of 1st layer
              
        for l = 1 : LAYER_COUNT - 1
              z = model{l}*activation{l} + bias{l};
              activation{l+1} = sigmoid(z);
        end
        [val ind] = max(activation{LAYER_COUNT}.');
        if ind ~= Target
            errorCount(i) = errorCount(i) + 1;
        end
    end    
end
disp(sum(errorCount)/TrainCount*100);