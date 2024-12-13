function combined_struct = combine_structs(varargin)
    % Check if there are at least two structs to combine
    if nargin < 2
        error('At least two structs are required.');
    end
    
    % Check if all input structs have the same fields
    fields = fieldnames(varargin{1});
    for i = 2:nargin
        if ~isequal(fieldnames(varargin{i}), fields)
            error('All structs must have the same fields.');
        end
    end
    
    % Initialize the combined struct with the same fields
    combined_struct = varargin{1};
    
    % Concatenate each field from all structs
    for i = 2:nargin
        for f = 1:numel(fields)
            field_name = fields{f};
            combined_struct.(field_name) = [combined_struct.(field_name), varargin{i}.(field_name)];
        end
    end
end
