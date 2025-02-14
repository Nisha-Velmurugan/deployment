FROM python:3.9
WORKDIR /app
COPY . /app
ENV PYTHONPATH=/app
RUN pip install -r requirements.txt
EXPOSE 5000
CMD ["python", "app/main.py"]
