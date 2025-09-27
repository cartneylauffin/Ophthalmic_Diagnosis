pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT = "<ACCOUNT_ID>"
        ECR_REPO_NAME = "ophthalmic-diagnosis"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        IMAGE_URI = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${ECR_REPO_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Authenticate to AWS ECR') {
            steps {
                echo "Authenticating Docker with AWS ECR..."
                sh '''
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
                '''
            }
        }

        stage('Create ECR Repository if Missing') {
            steps {
                echo "Ensuring ECR repository exists..."
                sh '''
                    aws ecr describe-repositories --repository-names ${ECR_REPO_NAME} --region ${AWS_REGION} || \
                    aws ecr create-repository --repository-name ${ECR_REPO_NAME} --region ${AWS_REGION}
                '''
            }
        }

        stage('Tag & Push Docker Image to ECR') {
            steps {
                echo "Pushing image to ECR..."
                sh '''
                    docker tag ${ECR_REPO_NAME}:${IMAGE_TAG} ${IMAGE_URI}
                    docker push ${IMAGE_URI}
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                echo "Triggering ECS service deployment..."
                script {
                    def CLUSTER_NAME = "<CLUSTER_NAME>"
                    def SERVICE_NAME = "<SERVICE_NAME>"
                    sh """
                        aws ecs update-service \
                            --cluster ${CLUSTER_NAME} \
                            --service ${SERVICE_NAME} \
                            --force-new-deployment \
                            --region ${AWS_REGION}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful! Image: ${IMAGE_URI}"
        }
        failure {
            echo "❌ Deployment failed."
        }
    }
}
