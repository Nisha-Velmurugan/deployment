FROM python:3.9

WORKDIR /app

COPY . /app

RUN pip install flask pytest

EXPOSE 5000

CMD ["python", "app/main.py"]
