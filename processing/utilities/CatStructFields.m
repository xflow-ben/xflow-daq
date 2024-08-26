function A = CatStructFieldsTwoLevel(S, T)
fields = fieldnames(S);
A = struct;
for k = 1:numel(fields)
  aField     = fields{k}; % EDIT: changed to {}
  A.(aField) = [S.(aField); T.(aField)];
end