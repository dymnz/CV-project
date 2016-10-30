Data = normrnd(0.5,0.1,1000,1);
Data(Data<0) = 0.001;

Z=gamfit(Data); % fitting distribution for shape and scale factor
[muhat,sigmahat] = normfit(Data);
X=0:0.001:1; % Duration of data
pdf=gampdf(X,Z(1),Z(2)); % pdf of the gamma distribution

figure;
plot(X, pdf);
figure;
pdf=normpdf(X,muhat,sigmahat); % pdf of the gamma distribution
plot(X, pdf);
