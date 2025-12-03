# base image
FROM python:3.11-slim

# set workdir
WORKDIR /app

# install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy app code
COPY app.py .

# expose port
EXPOSE 5000

# run the app
CMD ["python", "app.py"]

