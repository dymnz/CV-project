% Learning

LEARNING_RATE = 1;

LAYER_COUNT = 3;
NEURON_COUNTS = [DIMENSION round(DIMENSION/2) MAX_CLASS];
PARAM_COUNTS = [0 NEURON_COUNTS(1:end-1)];

bias = cell(1, LAYER_COUNT-1);
weight = cell(1, LAYER_COUNT-1);

for i = 1 : LAYER_COUNT-1
    weight{i} = 0.01 * randn(NEURON_COUNTS(i+1), PARAM_COUNTS(i+1));
    bias{i} = 0.01 * randn(NEURON_COUNTS(i+1), 1);
end

activation = cell(1, LAYER_COUNT);
delta = cell(1, LAYER_COUNT);
batchGW = cell(1, LAYER_COUNT-1);
batchGB = cell(1, LAYER_COUNT-1);


for itr = 1 : 500

errorCount = zeros(size(TrainSet));    
    
for i = 1 : LAYER_COUNT-1
    batchGW{i} = zeros(size(weight{i}));
    batchGB{i} = zeros(size(bias{i}));
end

L = 0;
gW = cell(1, LAYER_COUNT-1);
gB = cell(1, LAYER_COUNT-1);

for i = 1 : MAX_CLASS   
    Target = zeros(MAX_CLASS, 1); Target(i) = 1;    
    for r = 1 : size(TrainSet{i}, 1)	% For each sample    
        
        % Forward propagation
        activation{1} = TrainSet{i}(r, :).';  % Let X be the output of 1st layer
              
        for l = 1 : LAYER_COUNT - 1
              z = weight{l}*activation{l} + bias{l};
              activation{l+1} = sigmoid(z);
        end
        L = L + 0.5 * norm((activation{LAYER_COUNT} - Target), 2);        
        
        [val ind] = max(activation{LAYER_COUNT}.');
        if ind ~= Target
            errorCount(i) = errorCount(i) + 1;
        end
        
        % Backpropagation
        delta{LAYER_COUNT} = -(Target - activation{LAYER_COUNT}) .* ...
            (activation{LAYER_COUNT}.*(1-activation{LAYER_COUNT})) ;
        for l = LAYER_COUNT - 1: -1 : 1
            delta{l} = ((weight{l}')*delta{l+1}) .* ...
                (activation{l}.*(1-activation{l})) ;
        end
        
        for l = 1 : LAYER_COUNT - 1
            gW{l} = delta{l+1} * (activation{l}');
            gB{l} = delta{l+1};
            batchGW{l} = batchGW{l} + gW{l};
            batchGB{l} = batchGB{l} + gB{l};
        end
        
    end    
end

for i = 1 : LAYER_COUNT-1
    weight{i} = weight{i} - LEARNING_RATE .* (batchGW{i}./TrainCount);
    bias{i} = bias{i} - LEARNING_RATE .* (batchGB{i}./TrainCount);
end
L = L/TrainCount;
disp(L);
%disp(sum(errorCount));
end




