FROM python:3.5-slim
MAINTAINER Balthazar Rouberol <balthazar.rouberol@corp.ovh.net>

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

RUN mkdir /usr/src/app
WORKDIR /usr/src/app/

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . /usr/src/app/

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["api"]
USER user
