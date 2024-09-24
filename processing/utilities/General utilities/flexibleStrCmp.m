function isEqual = flexibleStrCmp(str1, str2)
  % Remove all spaces and convert to lowercase
    str1_clean = lower(regexprep(str1, '\s+', ''));
    str2_clean = lower(regexprep(str2, '\s+', ''));
    
    % Compare cleaned strings
    isEqual = strcmp(str1_clean, str2_clean);
end