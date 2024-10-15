function combined_struct = combine_nested_structs(varargin)
    % Check if there are at least two structs to combine
    if nargin < 2
        error('At least two structs are required.');
    end
    
    % Check if all input structs have the same fields at the top level
    fields = fieldnames(varargin{1});
    for i = 2:nargin
        if ~isequal(fieldnames(varargin{i}), fields)
            error('All structs must have the same top-level fields.');
        end
    end
    
    % Initialize the combined struct with the same fields
    combined_struct = varargin{1};
    
    % Concatenate each nested field from all structs
    for i = 2:nargin
        for f = 1:numel(fields)
            field_name = fields{f};
            % Get the nested struct for this field
            nested_struct = combined_struct.(field_name);
            nested_fields = fieldnames(nested_struct);
            
            % Check if all nested structs have the same fields
            for j = 1:nargin
                if ~isequal(fieldnames(varargin{j}.(field_name)), nested_fields)
                    error('All nested structs must have the same fields.');
                end
            end
            
            % Concatenate each nested field
            for nf = 1:numel(nested_fields)
                nested_field_name = nested_fields{nf};
                
                % Concatenate arrays across structs
                combined_data = nested_struct.(nested_field_name);
                for k = 2:nargin
                    combined_data = [combined_data, varargin{k}.(field_name).(nested_field_name)];
                end
                combined_struct.(field_name).(nested_field_name) = combined_data;
            end
        end
    end
end
