clc; clear;

load('assignmentImageDenoisingPhantom.mat');
L = 10;
X = abs(imageNoisy);
D = edge(X,'log');
[idx, C] = kmeans(X(:),L, 'MaxIter', 1000);
idx = reshape(idx,size(imageNoisy));
Y = zeros(size(X));
for l = 1:L
    Y = Y + (C(l).*(idx == l));
end
X = Y;
% X = ones(100)/2;
% for i = 20:30
%     for j = 5:95
%         X(i,j) = 1;
%     end
% end
% 
% for j = 30:70
%     for i = 5:95
%         X(i,j) = 1;
%     end
% end
% imshow(X);
% figure(2);
% p = repmat(0.2, 100, 100);
% P = rand(100);
% Y = (P<p).*(1.5-X) + (P>p).*X;
% imshow(Y)
I = zeros(L,1);
for l = 1:L
    I(l) = l/L;
end
initialState = X;
State = initialState;
S = size(State);
newState = zeros(S);
mu = 0;
sigmaG = 0.7;
c = 3;
sigmaN = 1;
lambda = log(0.8/0.2);
neighbors = zeros(4,1);
phi = zeros(L,1);
potential = zeros(L,1);
p = zeros(L+1,1);
for k = 1:60
    T = c/log(1+k);
    k
    tic;
    for i = 2:S(1)-1
        for j = 2:S(1)-1
         if(D(i,j) == 0)
             neighbors=[];
             iS=[];
             if(D(i-1,j) == 0)
                 neighbors=[neighbors,State(i-1,j)];
                 iS=[iS,initialState(i-1,j)];
             end 
             if(D(i,j+1) == 0)
                 neighbors=[neighbors,State(i,j+1)];
                 iS=[iS,initialState(i,j+1)];
             end 
             if(D(i,j-1) == 0)
                 neighbors=[neighbors,State(i,j-1)];
                 iS=[iS,initialState(i,j-1)];
             end
             if(D(i+1,j) == 0)
                 neighbors=[neighbors,State(i+1,j)];
                 iS=[iS,initialState(i+1,j)];
             end 
             siz=size(neighbors);
             if siz == 0
                 break;
             end
             %neighbors = [State(i-1,j), State(i+1,j), State(i,j-1), State(i,j+1)];
             %iS = [initialState(i-1,j), initialState(i+1,j), initialState(i,j-1), initialState(i,j+1)];
             for l = 1:L
                phi(l) = sum(((repmat(I(l),1,siz(2))-iS) - repmat(mu,1,siz(2))).^2)/(2*(sigmaG^2));
                potential(l) = (sum((3).*(neighbors~=I(l))) + lambda*(State(i,j) ~= I(l)))/T + phi(l);
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
            end
         end     
    end
    toc;
end
figure(3);
imshow(State);