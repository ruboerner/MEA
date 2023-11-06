function R = read_config(filename)
if isfile(filename)
    f = fopen(filename);
    while ~feof(f)
        s = strtrim(fgetl(f));
        % disp(s)
        if isempty(s)
            continue;
        end
        if (s(1) == '#')
            continue;
        end
        [par,val] = strtok(s, ':');
        res = strtrim(val);
        if strcmpi(res(1), ':')
            res(1) = [];
        end
        val = strtrim(res);
        R.(lower(genvarname(par))) = val;
    end

end
end