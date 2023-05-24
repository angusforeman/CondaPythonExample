"""
Hello World that determines at runtime if the python runtime
is within a contaner built using the associated dockerfile.
Also it prints the Conda environment name in which it is executing
"""
# import os module
import os

MSG = "Hello World from the Conda Python docker template example"
print(MSG)

IN_DOCKER_CONTAINER = os.environ.get('DOCKER_CONTAINER_RUNTIME', False)

if IN_DOCKER_CONTAINER:
    print('This is running in a Docker container')
else:
    print('This is NOT running in a Docker container')

# display all environment variable
print("Active Conda environment:", os.environ.get('CONDA_DEFAULT_ENV'))
