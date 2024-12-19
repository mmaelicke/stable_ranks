# Pull any base image that includes python3
FROM python:3.12

# install the toolbox runner tools
# for jupyter notebooks we need jupyter itself and papermill to execute them
RUN pip install \
    "json2args[data]>=0.7.0" \
    jupyter==1.1.1 \ 
    papermill==2.6.0 \
    matplotlib==3.9.2 \
    metacatalog-api==0.3.4 \
    anywidget==0.9.13 \
    tabulate==0.9.0

# create the tool input structure
RUN mkdir /in
COPY ./in /in
RUN mkdir /out
RUN mkdir /src
COPY ./src /src

# copy the citation file - looks funny to make COPY not fail if the file is not there
COPY ./CITATION.cf[f] /src/CITATION.cff

WORKDIR /src

# Use this for the finished tool
CMD ["python", "run.py"]

# use this command for development
#CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]