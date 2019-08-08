function Y = Potential(State, T, gamma)
    size(State)
  data_l = State - circshift(State,-1,[2]);
  data_r = State - circshift(State,1,[2]);
  data_u = State - circshift(State,-1,[1]);
  data_d = State - circshift(State,1,[1]);
    Y = sum(sum((gamma*abs(data_d) + gamma*abs(data_l) + gamma*abs(data_u) + gamma*abs(data_r) - gamma*gamma*log(1+(abs(data_d)./gamma))- gamma*gamma*log(1+(abs(data_u)./gamma)) - gamma*gamma*log(1+(abs(data_l)./gamma)) - gamma*gamma*log(1+(abs(data_r)./gamma)))))/T;