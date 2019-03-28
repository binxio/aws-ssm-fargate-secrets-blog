FROM alpine

# SSM Secret Sauce
RUN wget -O /usr/local/bin/ssm-env https://github.com/remind101/ssm-env/releases/download/v0.0.3/ssm-env
RUN echo "c944fc169d860a1079e90b03a8ea2c71f749e1265e3c5b66f57b2dc6e0ef84f8  /usr/local/bin/ssm-env" | sha256sum -c -
RUN chmod +x /usr/local/bin/ssm-env
RUN apk add --no-cache ca-certificates
ENTRYPOINT ["/usr/local/bin/ssm-env", "-with-decryption"]
# /SSM Secret Sauce

RUN apk add --no-cache py2-pip \
    && pip install --upgrade pip \
    && pip install flask \
    && pip install awscli \
    && pip install boto3

ENV APP_DIR /app
ENV FLASK_APP app.py
RUN mkdir ${APP_DIR}
COPY app ${APP_DIR}

ENV SECRET defaultsecret
ENV SECRET_DEFAULT defaultsecret

VOLUME ${APP_DIR}
EXPOSE 80

RUN rm -rf /.wh /root/.cache /var/cache /tmp/requirements.txt

WORKDIR ${APP_DIR}
CMD ["python", "app.py"]