FROM python:3.8.0-alpine

ENV APP_HOME=/home/app

# create directory base image
RUN mkdir -p /home/app

# create the app user
RUN addgroup -S app && adduser -S app -G app
WORKDIR $APP_HOME

# copy project
COPY ./app/* $APP_HOME/

RUN pip install -r requirements.txt

RUN chmod -R 755 $APP_HOME

# chown all files to the app user
RUN chown -R app:app $APP_HOME

# change to the app user
USER app

# Start app
CMD ["python", "app_runner.py"]
