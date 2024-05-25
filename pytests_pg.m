%%
if ismac
    pyenv( ...
        Version="/Users/rub/miniconda3/envs/pg/bin/python", ...
        ExecutionMode="OutOfProcess")
elseif ispc
    pyenv( ...
        Version="C:\Users\rub\miniconda3\envs\pg15\python", ...
        ExecutionMode="OutOfProcess")
end


%%


mpl = py.importlib.import_module('matplotlib');
% mpl.use('QtCairo');
plt = py.importlib.import_module('matplotlib.pyplot');

pg = py.importlib.import_module('pygimli');

ert = py.importlib.import_module('pygimli.physics.ert');


% mgr = ert.ERTManager('gallery.dat');
data = ert.load('farn_sb_01.mea');
data.estimateError();



mgr = ert.ERTManager(data);

mgr.invert(lam=20, verbose=true);

%%
mgr.showResult(); plt.show()
% py.matplotlib.pyplot.savefig('test_plot.png');

% pg.show(model); plt.show()

