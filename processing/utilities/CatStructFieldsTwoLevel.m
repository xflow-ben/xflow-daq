function A = CatStructFieldsTwoLevel(S, T)
fields1 = fieldnames(S);
A = struct;
for i = 1:numel(fields1)
    fields2 = fieldnames(S.(fields1{i}));
    for k = 1:numel(fields2)
        A.(fields1{i}).(fields2{k}) = [S.(fields1{i}).(fields2{k}), T.(fields1{i}).(fields2{k})];
    end
end