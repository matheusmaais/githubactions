Github Actions examples


name: test actions

on: 
  push:
    branches: [main]
  workflow_dispatch:

jobs:

  DeployDev: 
    name: Terraform plan
    if: github.event.ref == 'refs/heads/main'
    runs-on: ubuntu-20.04
    environment:
      name: Dev
    steps:
      - name: Deploy
        run: |
          echo Deu tudo Certo que maravilha!!
          touch test_file.txt
          echo "lerolero" > test_file.txt
          cat test_file.txt
        continue-on-error: false
  
  DeployProduction: 
    name: Deploy to Production Environment
    needs: [DeployDev]
    runs-on: ubuntu-20.04
    environment:
      name: Production
      url: 'http://production.myapp.com'
    steps:
      - name: Deploy
        run: echo I am Deploying!!
--------------
name: DEVELOPMENT - EKS Plan example

on:
  workflow_dispatch:
  pull_request:
    branches:
      - development
      - '**development'
jobs:
  vpc-plan:
    name: VPC Plan development-VPC
    runs-on: ubuntu-latest
    steps:

    - name: Checkout Repository development-VPC
      uses: actions/checkout@master

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
         aws-access-key-id: ${{ secrets.ACCESS_KEY }}
         aws-secret-access-key: ${{ secrets.SECRET_KEY }}
         aws-region: us-east-1

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 0.13.5

  eks-cluster-plan:
    name: EKS-Cluster TF Plan development-EKS
    needs: vpc-plan
    runs-on: ubuntu-latest
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.ACCESS_KEY }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.SECRET_KEY }}
      AWS_DEFAULT_REGION: us-east-1
      AWS_REGION: us-east-1
   
   steps:
    - name: Checkout Repository
      uses: actions/checkout@master

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.ACCESS_KEY }}
        aws-secret-access-key: ${{ secrets.SECRET_KEY }}
        aws-region: us-east-1
        
    - name: Authenticate Kubectl With AWS
      run: aws eks update-kubeconfig --name my_eks_cluster
    
    - name: Switch namespace
      run: |
        kubectl config set-context --current
        export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config
    
    - name: Kubectl checks
      run: |
        kubectl version --short --client
        kubectl get pods --all-namespaces
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 0.13.5

    - name: Terraform Fmt development-VPC
      id: fmt
      run: |
        cd eks-cluster/
        terraform fmt
      continue-on-error: false

    - name: Terraform Init
      id: init
      run: |
        cd eks-cluster/
        terraform init
      continue-on-error: false

    - name: Terraform Validate
      id: validate
      run: |
        cd eks-cluster/
        terraform validate
      continue-on-error: false

    - name: Terraform Plan
      id: plan
      run: |
        sleep 20
        cd eks-cluster/
        kubectl version --short --client
        kubectl get pods --all-namespaces
        terraform plan
      continue-on-error: false




