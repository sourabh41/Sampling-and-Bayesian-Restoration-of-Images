clc; clear; 

X = ones(100)/2;
for i = 20:30
    for j = 5:95
        X(i,j) = 1;
    end
end

for j = 30:70
    for i = 5:95
        X(i,j) = 1;
    end
end
imshow(X);
figure(2);
p = repmat(0.2, 100, 100);
P = rand(100);
Y = (P<p).*(1.5-X) + (P>p).*X;
imshow(Y)
