MDRP = zeros(size(logspace(-3, -0.5)));
VDRP = zeros(size(logspace(-3, -0.5)));
for i = 1 : size(logspace(-3, -0.5), 2)
    VDRP(i) = sum(VD(i, :));
    MDRP(i) = sum(MD(i, :));
end

semilogy(logspace(-3, -0.5), VDRP);

legend('Diff Var');
xlabel('Noise variance');
ylabel('|Diff|');
hold off;

[val, ind] = min(VDRP);
A = logspace(-3, -0.5);
disp(A(ind));