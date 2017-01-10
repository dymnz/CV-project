function phi = findHomography(W, T, NumOfIterations)
% Find Corresponding Points Using SURF Features 
% INPT: W: Nx2 matrix. The [x y] coordinates of world FPs
%       T: Nx2 matrix. The [x y] coordinates of target FPs
%       NumOfIterations: The # of maximum iterations for non-linear optimization
% OUPT: phi: 1x9 vector. The vectorized homography parameters

NumOfMPs = size(W, 1);

% Append 1 for homogenous coordinate
W = [W ones(NumOfMPs, 1)];
T = [T ones(NumOfMPs, 1)];

A = zeros(2*NumOfMPs, 9);
for i = 1 : NumOfMPs
    w = W(i, :);
    x = T(i, :);
    a = [0 0 0 -w x(2)*w; ...
          w 0 0 0 -x(1)*w];
    A((i-1)*2+1:i*2, :) = a;
end
[U,S,V] = svd(A);
phi = V(:, 9);

% Reparameterize Phi
phi(1) = phi(1) + 1;
phi(5) = phi(5) + 1;
phi = phi(1:8);
exphi = [phi(1:8);1];

T = T(:, 1:2);
X = zeros(NumOfMPs, 2);

for iteration = 1 : NumOfIterations

% Find Psi
exphi = [phi(1:8);1];
denom = W*exphi(7:9);
x = W*exphi(1:3)./denom;
y = W*exphi(4:6)./denom;
X = [x y];
psi = T - X;

% Construct J
J = zeros(2*NumOfMPs, 8);
for i = 1 : NumOfMPs
    w = W(i, :);
    x = T(i, :);
    j = [w 0 0 0 -x(1)*w(1) -x(1)*w(2); ...
         0 0 0 w -x(2)*w(1) -x(2)*w(2)];
    J((i-1)*2+1:i*2, :) = j./(w*exphi(7:9));
end

% Find A and b
A = zeros(8, 8);
b = zeros(8, 1);
for i = 1 : NumOfMPs
    j = J((i-1)*2+1:i*2, :);
    A = A + j'*j;
    b = b + j'*psi(i, :)';
end

if numel(find(isinf(A))) ~= 0 || numel(find(isnan(A)))
    break;
end

% Find gradient
% dPhi = pinv(A)*b;
dPhi = inv(A)*b;
phi = phi + dPhi;

% Stop when the projection error is 0
AvgError = (sum(abs(psi(:, 1))) + sum(abs(psi(:, 2))))/2/size(psi, 1);
if AvgError == 0
    break;
end

end
phi = [phi(1:8);1];
% disp(sprintf('for i=%d: %.2f %.2f', iteration, sum(abs(psi(:, 1))), sum(abs(psi(:, 2)))));
end
