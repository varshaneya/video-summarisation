%%% Knapsack demonstration
% �nteger weights of items
N = 12;
weights = randi([1 1000],1,N);
%%
% Values of the items (don't have to be integers)
values = randi([1 100],1,N);

%% Solve the knapsack problem
% Call the provided m-file
capacity = 3000;
[best amount] = knapsack(weights, values, capacity);
best
items = find(amount)
%%
% Check that the result matches the contraint and the best value
sum(weights(items))
sum(values(items))