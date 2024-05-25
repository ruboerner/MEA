% test_matplotlib.m
if count(py.sys.path, '') == 0
    insert(py.sys.path, int32(0), '');
end

try
    py.importlib.import_module('matplotlib');
    disp('Matplotlib imported successfully');
catch
    disp('Failed to import Matplotlib');
end

try
    py.importlib.import_module('matplotlib.pyplot');
    disp('matplotlib.pyplot imported successfully');
catch
    disp('Failed to import matplotlib.pyplot');
end

% Simple plot
py.matplotlib.pyplot.plot(py.list({1,2,3}), py.list({4,5,6}));
py.matplotlib.pyplot.savefig('test_plot.png');
