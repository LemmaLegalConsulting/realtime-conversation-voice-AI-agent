# Use an official Python runtime as a parent image
FROM python:3.10-bullseye

# eMudhra certificate incident: refresh each stage's system trust store.
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && update-ca-certificates && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --no-cache-dir --upgrade "pip @ https://files.pythonhosted.org/packages/3f/06/3e4420302363fbb71be3c7f35ce042f54bfca330e3e66b3a2e3c4cca579f/pip-26.2.2-py3-none-any.whl#sha256=fd7f4dfa8190e014013b9f08f3e973f4e4c26ffd179a204895533a7254813a70" \
    && python -m pip install --no-cache-dir --upgrade "certifi>=2026.10.19"

# Set the working directory in the container
WORKDIR /twilio-chatbot

# Copy the requirements file into the container
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container
COPY . .

# Expose the desired port
EXPOSE 8765

# Run the application
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8765"]
