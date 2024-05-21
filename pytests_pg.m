% pyversion('/Users/rub/miniconda3/envs/pg/bin/python');
pyenv("ExecutionMode","OutOfProcess")
pg = py.importlib.import_module('pygimli');

%ERTManager = py.importlib.import_module('pygimli.physics.ert');

ert = py.importlib.import_module('pygimli.physics.ert');

%wenner = pg.load('mactest.mea');

% ertwenner = ert.ertManager;

%modwenner = ertwenner.invert(wenner)

mgr = ert.ERTManager('mactest.mea');

model = mgr.invert(lam=20);

% mgr.showResult()
