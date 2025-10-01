FROM python:3.12-slim

WORKDIR /app

# add group and user to run a container
RUN groupadd -r webservice && useradd --no-log-init -r -g webservice webservice

# this will install some packages
RUN pip install streamlit requests

COPY ./web .

# USER webservice:webservice commented out to allow writing to local filesystem


# indicates the ports on which a container listens for connections
EXPOSE 8050

CMD ["streamlit", "run", "app.py", "--server.port=8050"]
