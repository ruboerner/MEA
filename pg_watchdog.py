import marimo

__generated_with = "0.6.0"
app = marimo.App(layout_file="layouts/pg_watchdog.grid.json")


@app.cell
def __():
    import marimo as mo
    return mo,


@app.cell
def __():
    import pygimli as pg
    from pygimli.physics.ert import ERTManager
    from pygimli.physics import ert
    import numpy as np
    import matplotlib.pyplot as plt
    return ERTManager, ert, np, pg, plt


@app.cell
def __():
    #from contextlib import contextmanager
    import logging, sys, os
    logging.disable(sys.maxsize)
    return logging, os, sys


@app.cell
def __(ERTManager, ert, pg, plt):
    fig, ax = plt.subplots(1,1, figsize=(8,4))
    wenner = pg.load("mactest.mea")
    ertwenner = ERTManager()
    wenner['err'] = ertwenner.estimateError(wenner, absoluteError=0.1, relativeError=0.03)
    wenner['k'] = ert.geometricFactors(wenner)
    modwenner = ertwenner.invert(wenner, lam=3, paraMaxCellSize=0.2, paraDepth=4, verbose=False)

    ertwenner.showModel(modwenner, ax=ax, cMap="RdBu_r", cMin=1, cMax=100);
    ax
    return ax, ertwenner, fig, modwenner, wenner


@app.cell
def __():
    return


if __name__ == "__main__":
    app.run()
