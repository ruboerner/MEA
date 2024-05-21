% pyversion('/Users/rub/miniconda3/envs/pg/bin/python');

pg = py.importlib.import_module('pygimli');

%ERTManager = py.importlib.import_module('pygimli.physics.ert');

ert = py.importlib.import_module('pygimli.physics.ert');

%wenner = pg.load('mactest.mea');

% ertwenner = ert.ertManager;

%modwenner = ertwenner.invert(wenner)

mgr = ert.ERTManager('mactest.mea');

mgr.invert(lam=20)
