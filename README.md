# k8s-pod-to-s3-example
Please follow the steps to setup S3 buckets and deploy the app. It is assumed that AWS account is setup and EKS cluster already exist.

# Create buckets:
cd ./iac/qa_bucket/
terraform init
terraform plan
terraform apply

cd ..
cd ./prod_bucket/
terraform init
terraform plan
terraform apply

# Make a note of IAM policy ARN
cd ..
cd ./iam
terraform init
terraform plan
terraform apply


# Build and Push App docker image, please use the ECR path as per the AWS account
cd ..
export ECR_REPO=221867667342.dkr.ecr.ap-south-1.amazonaws.com/ecr-test-repo1
docker build -t $ECR_REPO:my-python-app-1 .
docker push $ECR_REPO:my-python-app-1

# Create the deployment setup in EKS cluster
# Create service account and map it to IAM Role and Policy to get access to write to S3. Use the policy ARN recived from previos steps 
kubectl apply -f namespaces.yaml
eksctl create iamserviceaccount --name my-service-acc1 --namespace prod --cluster cluster1 --attach-policy-arn arn:aws:iam::221867667342:policy/my-app-s3-policy
eksctl create iamserviceaccount --name my-service-acc1 --namespace prod --cluster cluster1 --attach-policy-arn arn:aws:iam::221867667342:policy/my-app-s3-policy --approve

eksctl create iamserviceaccount --name my-service-acc1 --namespace qa --cluster cluster1 --attach-policy-arn arn:aws:iam::221867667342:policy/my-app-s3-policy
eksctl create iamserviceaccount --name my-service-acc1 --namespace qa --cluster cluster1 --attach-policy-arn arn:aws:iam::221867667342:policy/my-app-s3-policy --approve


# Please ensure that correct image path is mentrioned in the following files
kubectl apply -f my-python-app-cron-qa.yaml
kubectl apply -f my-python-app-cron-prod.yaml

# Check the app
kubectl -n qa get cronjob
kubectl -n qa get po -w

kubectl -n prod get cronjob
kubectl -n prod get po -w

# Check app logs to see of it is writing the files to S3
kubectl -n qa log my-python-app-27574362-nhczm
kubectl -n prod logs -f my-python-app-27574412-p452m


<img width="1397" alt="image" src="https://user-images.githubusercontent.com/26666587/172074452-65f7ec57-807c-47f1-88b8-ce00a7cdd4bb.png">
<img width="1397" alt="image" src="https://user-images.githubusercontent.com/26666587/172074473-1b5fea15-3e6c-4f14-8786-1926282ec1c0.png">
<img width="288" alt="image" src="https://user-images.githubusercontent.com/26666587/172074506-b7914445-f3f2-4176-aa8f-0520277f7d27.png">
<img width="376" alt="image" src="https://user-images.githubusercontent.com/26666587/172074515-d8b5c5e9-ac2a-43bf-9072-3ebb63cce813.png">


