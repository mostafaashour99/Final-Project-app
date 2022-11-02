FROM python
WORKDIR /app/python
COPY ./DevOps-Challenge-Demo-Code /app/python

ENV ENVIRONMENT=DEV
ENV PORT=8000
ENV REDIS_PORT=6379
ENV REDIS_DB=0

EXPOSE 8000
RUN pip install -r requirements.txt

ENTRYPOINT [ "python","hello.py"]		
