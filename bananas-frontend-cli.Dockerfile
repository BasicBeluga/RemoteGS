FROM python:3.9

RUN apt install git
RUN git clone https://github.com/OpenTTD/bananas-frontend-cli.git bananas-frontend-cli
WORKDIR bananas-frontend-cli
RUN python3 -m venv .env
RUN .env/bin/pip install -r requirements.txt