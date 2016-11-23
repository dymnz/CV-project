
figure; 
scatter(TRAINSET_COUNTS, corretPTrain);
hold on;
scatter(TRAINSET_COUNTS, corretPTest);
axis([0, 200, 0, 100]);
legend('Train','Test');
title('Classification rate vs. # of training samples');