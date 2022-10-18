# k8s-pod-to-s3-example
Please follow the steps to setup S3 buckets and deploy the app. It is assumed that AWS account is setup and EKS cluster already exist. <br />

# Create buckets: <br />
cd ./iac/qa_bucket/ <br />
terraform init <br />
terraform plan <br />
terraform apply <br />

cd .. <br />
cd ./prod_bucket/ <br />
terraform init <br />
terraform plan <br />
terraform apply <br />

# Make a note of IAM policy ARN <br />
cd .. <br />
cd ./iam <br />
terraform init <br />
terraform plan <br />
terraform apply <br />


# Build and Push App docker image, please use the ECR path as per the AWS account <br />
cd .. <br />
export ECR_REPO=<account>.dkr.ecr.ap-south-1.amazonaws.com/ecr-test-repo1  <br />
docker build -t $ECR_REPO:my-python-app-1 .  <br />
docker push $ECR_REPO:my-python-app-1  <br />

# Create the deployment setup in EKS cluster  <br />
# Create service account and map it to IAM Role and Policy to get access to write to S3. Use the policy ARN recived from previos steps   <br />
kubectl apply -f namespaces.yaml <br />
eksctl create iamserviceaccount --name my-service-acc1 --namespace prod --cluster cluster1 --attach-policy-arn arn:aws:iam::<account>:policy/my-app-s3-policy <br />
eksctl create iamserviceaccount --name my-service-acc1 --namespace prod --cluster cluster1 --attach-policy-arn arn:aws:iam::<account>:policy/my-app-s3-policy --approve  <br />

eksctl create iamserviceaccount --name my-service-acc1 --namespace qa --cluster cluster1 --attach-policy-arn arn:aws:iam::<account>:policy/my-app-s3-policy <br />
eksctl create iamserviceaccount --name my-service-acc1 --namespace qa --cluster cluster1 --attach-policy-arn arn:aws:iam::<account>:policy/my-app-s3-policy --approve <br />


# Please ensure that correct image path is mentrioned in the following files <br />
kubectl apply -f my-python-app-cron-qa.yaml  <br />
kubectl apply -f my-python-app-cron-prod.yaml   <br />

# Check the app <br />
kubectl -n qa get cronjob <br />
kubectl -n qa get po -w <br />

kubectl -n prod get cronjob <br />
kubectl -n prod get po -w <br />

# Check app logs to see of it is writing the files to S3 <br />
kubectl -n qa log my-python-app-27574362-nhczm <br />
kubectl -n prod logs -f my-python-app-27574412-p452m <br />


<img width="1397" alt="image" src="https://user-images.githubusercontent.com/26666587/172074452-65f7ec57-807c-47f1-88b8-ce00a7cdd4bb.png"> <br />
<img width="1397" alt="image" src="https://user-images.githubusercontent.com/26666587/172074473-1b5fea15-3e6c-4f14-8786-1926282ec1c0.png"> <br />
<img width="288" alt="image" src="https://user-images.githubusercontent.com/26666587/172074506-b7914445-f3f2-4176-aa8f-0520277f7d27.png"> <br />
<img width="376" alt="image" src="https://user-images.githubusercontent.com/26666587/172074515-d8b5c5e9-ac2a-43bf-9072-3ebb63cce813.png"> <br />


