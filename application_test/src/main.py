from flask import Flask
import os
import boto3
import logging

logger = logging.getLogger(__name__)

app = Flask(__name__)

class GetSecretWrapper:
    def __init__(self, secretsmanager_client):
        self.client = secretsmanager_client

    def get_secret(self, secret_name):
        try:
            get_secret_value_response = self.client.get_secret_value(
                SecretId=secret_name
            )
            return get_secret_value_response["SecretString"]
        except self.client.exceptions.ResourceNotFoundException:
            msg = f"The requested secret {secret_name} was not found."
            return msg
        except Exception as e:
            logger.error(f"An unknown error occurred: {str(e)}.")
            raise

def get_secret(secret_name, region_name):
    session = boto3.session.Session()
    client = session.client(
        service_name="secretsmanager",
        region_name=region_name
    )

    secret = GetSecretWrapper(client)
    return secret.get_secret(secret_name)

@app.route('/secret')
def home():
    secret_name = "TestSecret"
    region_name = "us-east-1"
    secret_value = get_secret(secret_name, region_name)

    return secret_value

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
    