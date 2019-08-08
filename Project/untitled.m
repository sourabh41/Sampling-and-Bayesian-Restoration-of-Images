clc; clear;

load('assignmentImageDenoisingPhantom.mat');
L = 5;
% X = phantom(128);
% D = edge(X,'log');
% X = X/max(max(X));
% X = L*X;
% X = ceil(X)/L;
% figure(1);
% imshow(X);
X = ones(100)/5;
for i = 50:80
    for j = 5:95
        X(i,j) = 0.6;
    end
end

for i = 85:99
    for j = 35:80
        X(i,j) = 0.4;
    end
end

for i = 5:90
    for j = 60:70
        X(i,j) = 0.6;
    end
end

for j = 10:30
    for i = 5:95
        X(i,j) = 0.8;
    end
end

for j = 5:95
    for i = 10:30
        X(i,j) = 1;
    end
end

figure(1);
imshow(X);
D = edge(X,'log');
figure(2);
% p = repmat(0.2, 100, 100);
% P = rand(100);
% Y = (P<p).*(1.1-X) + (P>p).*X;
intImage = integralImage(X);
avgH = integralKernel([1 1 3 3], 1/9);
X = integralFilter(intImage, avgH);
X = imnoise(X, 'gaussian', 0 , 0.02);
imshow(X);
I = zeros(L,1);
for l = 1:L
    I(l) = l/L;
end
initialState = X;
State = initialState;
S = size(State);
mu = 0;
sigmaG = 0.2;
c = 3;
p = 0.2;
beta = 3;
lambda = log((1-p)/p);
neighbors = zeros(4,1);
phi = zeros(L,1);
potential = zeros(L,1);
p = zeros(L+1,1);
iS = zeros(4,1);
for k = 1:300
    T = c/(1+log(k));
    k
    tic;
    for i = 2:S(1)-1
        for j = 2:S(1)-1
            if (D(i,j) == 0)
                if(D(i-1,j) == 0)
                    neighbors(1) = State(i-1,j);
                    iS(1) = initialState(i-1,j);
                end 
                if(D(i,j+1) == 0)
                    neighbors(2) = State(i,j+1);
                    iS(2) = initialState(i,j+1);
                end 
                if(D(i,j-1) == 0)
                    neighbors(3) = State(i,j-1);
                    iS(3) = initialState(i,j-1);
                end
                if(D(i+1,j) == 0)
                    neighbors(4) = State(i+1,j);
                    iS(4) = initialState(i+1,j);
                end 
                neighbors = nonzeros(neighbors);
                iS = nonzeros(iS);
                siz = size(neighbors);
                if siz == 0
                    break;
                end
                %neighbors = [State(i-1,j), State(i+1,j), State(i,j-1), State(i,j+1)];
                %iS = [initialState(i-1,j), initialState(i+1,j), initialState(i,j-1), initialState(i,j+1)];
                for l = 1:L
                    phi(l) = sum(((repmat(I(l),1,siz(2))-iS) - repmat(mu,1,siz(2))).^2)/(2*(sigmaG^2));
                    potential(l) = (sum(beta.*(neighbors~=I(l))) + lambda*(State(i,j) ~= I(l)))/T + phi(l);
                end
                for l = 1:L
                    p(l) = exp((-1)*potential(l))/sum(exp((-1)*potential));
                end
                e = rand(1);
                pl = p(1);
                for l = 1:L
                    if e < pl
                        State(i,j)=I(l);
                        break;
                    else
                        pl= pl+ p(l+1);   
                    end    
                end
            else
                if (D(i-1,j) == 0)
                    State(i,j) = State(i-1,j);
                elseif (D(i,j-1) == 0)
                    State(i,j) = State(i,j-1);
                end   
            end
        end        
    end
    toc;
end
figure(4);
imshow(State);