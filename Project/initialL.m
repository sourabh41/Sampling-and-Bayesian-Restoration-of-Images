function Y = initialL(State,initialState,mu,sigma)
    phi = State-initialState;
    Y = ((phi-mu).^2);
    Y = sum(sum(Y))/(2*(sigma^2));