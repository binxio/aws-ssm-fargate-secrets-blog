from flask import Flask
import boto3
import os

app = Flask(__name__)

def ssm_secret(path, prefix = "ssm_sdk://"):
    client = boto3.client('ssm') # uses the container role
    prefix_len = len(prefix)
    if os.environ['SECRET_SDK'][0:prefix_len] == prefix:
        result = client.get_parameter(
            Name=os.environ['SECRET_SDK'][prefix_len:],
            WithDecryption=True
        )
        secret = result['Parameter']['Value']
    else: 
        secret = os.environ['SECRET_SDK']
    return secret

@app.route("/")
def hello():
    # section 1: get the secret and decrypt it using the sdk
    secret = ssm_secret(
        os.environ['SECRET_SDK'],
        os.environ['SECRET_SDK_PREFIX']
    )
    section1 = "SDK decrypted: " + secret
    # section 2: get the already decrypted secret
    section2 = "Ssn-env decrypted: " + os.environ['SECRET']
    return section1 + section2

app.run(host='0.0.0.0', port=80)