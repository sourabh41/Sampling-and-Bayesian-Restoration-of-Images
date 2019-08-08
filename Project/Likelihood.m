function Y = Likelihood(State, initialState, mu, sigma, i, j)
    phi = State - initialState;
    Y = ((phi(i-1,j-1) - mu)^2 + (phi(i,j-1) - mu)^2 + (phi(i+1,j-1) - mu)^2 + (phi(i-1,j) - mu)^2 + (phi(i+1,j) - mu)^2 + (phi(i-1,j+1) - mu)^2 + (phi(i,j+1) - mu)^2 + (phi(i+1,j+1) - mu)^2)/(2*sigma^2);