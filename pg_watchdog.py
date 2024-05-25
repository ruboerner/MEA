import marimo

__generated_with = "0.6.4"
app = marimo.App()


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
    import logging, sys, os
    logging.disable(sys.maxsize)
    return logging, os, sys


@app.cell
def __(mo):
    mo.md(rf"# Widerstandsgeoelektrik")
    return


@app.cell
def __(mo):
    fn = mo.ui.file_browser(filetypes=[".mea"], restrict_navigation=True, multiple=False)
    fn
    return fn,


@app.cell
def __(fn):
    fn.path()
    return


@app.cell
def __(mo):
    refresh_button = mo.ui.refresh(default_interval='15s')
    refresh_button
    return refresh_button,


@app.cell
def __(ert, fn, plt):
    # refresh_button
    fig, ax = plt.subplots(1,1, figsize=(8,4))

    mgr = ert.ERTManager(fn.path())
    mgr.data.estimateError()
    mgr.data.remove(mgr.data['rhoa'] < 0)

    inv = mgr.invert(lam=2, paraDepth=5, paraMaxCellSize=0.5)
    mgr.showModel(inv, ax=ax, cMap="RdBu_r");
    ax
    return ax, fig, inv, mgr


@app.cell
def __():
    return


@app.cell
def __(mo):
    mo.md(rf"# Result")
    return


@app.cell
def __():
    return


if __name__ == "__main__":
    app.run()
