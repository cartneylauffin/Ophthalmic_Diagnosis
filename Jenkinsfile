pipeline {
  agent any

  environment {
    // Set these as Jenkins credentials or global env vars (see setup steps)
    AWS_REGION    = "us-east-1"              // change to your region
    AWS_ACCOUNT   = "${env.AWS_ACCOUNT_ID}"  // set as env var or Jenkins credential
    ECR_REPO_NAME = "ophthalmic-diagnosis"   // ECR repo name you will create
    IMAGE_TAG     = "${env.BUILD_NUMBER ?: 'latest'}"
    IMAGE_URI     = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        echo "Checking out source from Git"
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        echo "Building Docker image: ${IMAGE_URI}"
        script {
          sh "docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Authenticate to ECR') {
      steps {
        // Assumes AWS credentials (AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY) are available
        echo "Logging in to Amazon ECR"
        script {
          sh '''
            aws --version
            aws ecr get-login-password --region ${AWS_REGION} | \
              docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
          '''
        }
      }
    }

    stage('Create ECR repo (if missing)') {
      steps {
        echo "Create ECR repository if it doesn't exist (idempotent)"
        script {
          sh '''
            aws ecr describe-repositories --repository-names ${ECR_REPO_NAME} --region ${AWS_REGION} || \
            aws ecr create-repository --repository-name ${ECR_REPO_NAME} --region ${AWS_REGION}
          '''
        }
      }
    }

    stage('Tag & Push to ECR') {
      steps {
        echo "Tagging and pushing to ECR: ${IMAGE_URI}"
        script {
          sh '''
            docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${IMAGE_URI}
            docker push ${IMAGE_URI}
          '''
        }
      }
    }

    stage('Trigger ECS Deployment') {
      steps {
        echo "Forcing ECS service to deploy the new image (replace cluster/service names below)"
        script {
          // Replace CLUSTER_NAME and SERVICE_NAME with your ECS cluster and service
          def CLUSTER_NAME = "my-ecs-cluster"
          def SERVICE_NAME = "ophthalmic-service"

          sh """
            # This forces ECS to do a new deployment. 
            # If your task definition uses :latest you can use force-new-deployment. 
            # For pinned tags you should register a new task definition revision that references ${IMAGE_URI}.
            aws ecs update-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --force-new-deployment --region ${AWS_REGION}
          """
        }
      }
    }
  }

  post {
    success {
      echo "Pipeline successful. Image pushed: ${IMAGE_URI}"
    }
    failure {
      echo "Pipeline failed."
    }
  }
}
