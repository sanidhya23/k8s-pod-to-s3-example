import boto3
from datetime import datetime
import os

class MyApp:
    """Class for App data and function"""
    def __init__(self, app_env, bucket_base_name):
        self.app_env = app_env
        self.bucket_name = f"{app_env}-{bucket_base_name}"

    def create_file(self, data=""):
        """ Writes file to app's s3 bucket """
        status = True
        now = datetime.now() # current date and time
        file_name = "{}__data.txt".format(now.strftime("%m-%d-%Y__%H-%M-%S"))
        try:
            s3 = boto3.resource('s3')
            object = s3.Object(self.bucket_name, file_name)
            object.put(Body=data)
        except Exception as e:
            print("Error: Could not write file")
            print(f"Exception: {e}")
            status = False
        return status
