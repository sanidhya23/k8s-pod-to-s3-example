from MyApp import MyApp
import time
import os

if __name__ == "__main__":
    # App entrypoint
    print("------------------")
    print("Starting the App")
    print("------------------")
    
    # Initialise config 
    app_env = os.environ.get('APP_ENV', 'qa')
    bucket_base_name = os.environ.get('BUCKET_BASE_NAME', 'sanidhya-pagare-platform-challenge')

    # Create app instance
    my_app = MyApp(app_env, bucket_base_name)
    
    # Write file to bucket
    status = my_app.create_file(data="Hello World!")
    
    # Placeholder sleep
    time.sleep(20)

    if status:
        print("Info: successfully created file")

