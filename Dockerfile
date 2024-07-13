# Uses the official Python 3.8 slim image
FROM python:3.8-slim

# Set working directory inside the container
WORKDIR /app
# Copy all files from from the current directory on the host to the /app directory in the container.
COPY . .

# Install the dependencies
RUN pip install --no-cache-dir -e .

#Runs the setup.py script to install the Python package. 
RUN python3 setup.py install
# Sets environment variable FLASK_APP to hello.
ENV FLASK_APP=hello

# Container will listen on this port at runtime (Default Flask port)
EXPOSE 5000

# Runs the Flask development server, making it accessible on all network interfaces (default command)
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]

# Sets the entry point for the Docker container. 
ENTRYPOINT ["flask", "run"]