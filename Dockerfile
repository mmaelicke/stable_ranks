# Pull any base image that includes python3
FROM python:3.12

# install the toolbox runner tools
# for jupyter notebooks we need jupyter itself and papermill to execute them
RUN pip install \
    "json2args[data]>=0.7.0" \
    jupyter==1.1.1 \ 
    papermill==2.6.0 \
    matplotlib==3.9.2 \
    metacatalog-api==0.2.1 \
    duckdb==1.1.3 \ 
    polars==1.14.0 \
    altair==5.4.1 \
    folium==0.18.0 \
    "vegafusion[embed]==1.6.9" \
    anywidget==0.9.13 \
    tabulate==0.9.0

# if you do not need data-preloading as your tool does that on its own
# you can use this instread of the line above to use a json2args version
# with less dependencies
# RUN pip install json2args>=0.7.0

# Do anything you need to install tool dependencies here
# RUN echo "Replace this line with a tool"

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src

# Use this for the finished too
CMD ["python", "run.py"]

# use this command for development
#CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]