FROM python:3.5

WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt 

RUN python3 -m spacy download en
RUN python3 -m spacy download de
RUN python3 -m spacy download es
RUN python3 -m spacy download pt
RUN python3 -m spacy download fr
RUN python3 -m spacy download it
RUN python3 -m spacy download nl

COPY . .

RUN cd /tmp \
    && git clone https://github.com/facebookresearch/fastText.git \
    && cd fastText \
    && make \
    && cp /tmp/fastText/fasttext /usr/local/bin \
    && cd / \
    && rm -fr /tmp/fastText

RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
