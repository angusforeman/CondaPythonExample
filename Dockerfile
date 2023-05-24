# For more information, please refer to https://aka.ms/vscode-docker-python
FROM continuumio/miniconda3
# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

#create an environment variable that will persist into the execution of the pythin runtime in the image that tells us if the code is running in a container
ENV DOCKER_CONTAINER_RUNTIME Yes

#Added from https://pythonspeed.com/articles/activate-conda-dockerfile/
RUN conda create --name condaondocker python=3.10 

# Note that this docker example is creating the conda environment using the --name syntax
# and that all the below refernces to the environment name must 
# match that specific environment name (e.g. 'condaondocker')
#alternatively you can create from a pre-made environment file
#but its still necessary to ensure that below use of the environment 
#names match that in the *file*   
#RUN conda env create --file=environment.yml

# Make RUN commands use the new environment (make sure the env-name matches the above and below refernces):
SHELL ["conda", "run", "-n", "condaondocker", "/bin/bash", "-c"]

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
COPY run.py .

#if you need to interactivelyt interroagate the Conda docker environment comment out the below and use "condat activate <env-name> 
#e.g. to generate docker base image specific environment file details
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "condaondocker", "python", "run.py"]
