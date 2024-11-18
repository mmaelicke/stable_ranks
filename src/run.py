import os
import sys
from datetime import datetime as dt
from pathlib import Path
import papermill as pm

from json2args import get_parameter
from json2args.data import get_data_paths
from json2args.logger import logger
import logging

# parse parameters
kwargs = get_parameter()
data = get_data_paths()

# check if a toolname was set in env
toolname = os.environ.get('TOOL_RUN', 'foobar').lower()
logger.info(f"##Tool Start - {toolname}")

# make sure that a jupyter notebook named like the tool is available.
# the file extension is optional
tool_notebook = Path(f"/src/{toolname.replace('.ipynb', '')}.ipynb")
if not tool_notebook.exists():
    logger.error(f"[{dt.now().isocalendar()}] No notebook found for tool '{toolname}'. Following the config, I expect a notebook called {tool_notebook} inside the container.\n")
    sys.exit(1)

# before running the notebook, we overwrite the papermill logger with the json2args logger
pm_logger = logging.getLogger('papermill')
pm_logger.setLevel(getattr(logging, os.environ.get('LOG_LEVEL', 'INFO')))
pm_logger.handlers = logger.handlers

# run the notebook.
# the output is written to /out
# the kwargs and data are passed as parameters to the notebook
pm.execute_notebook(
    tool_notebook,
    Path("/out") / tool_notebook.name,
    parameters={**kwargs, **data},
    log_output=True,
)

logger.info(f"##Tool Finish - {toolname}")
