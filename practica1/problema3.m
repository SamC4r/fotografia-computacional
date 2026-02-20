
v = 0:0.01:1;

a = size(v);

for i = 1:a(1,2)
    vq(1,i) = quant(v(1,i), 8);
end

plot(v, vq, 'LineWidth', 1.5);