pipeline {
    agent any

    environment {
        IMAGE_NAME = "ophthalmic_diagnosis"
        IMAGE_TAG  = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/cartneylauffin/Ophthalmic_Diagnosis.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Stop Old Container') {
            steps {
                script {
                    sh """
                    docker ps -q --filter "name=${IMAGE_NAME}" | grep -q . && docker stop ${IMAGE_NAME} || true
                    docker ps -a -q --filter "name=${IMAGE_NAME}" | grep -q . && docker rm ${IMAGE_NAME} || true
                    """
                }
            }
        }

        stage('Run New Container') {
            steps {
                sh "docker run -d --name ${IMAGE_NAME} -p 8501:8501 ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
            echo '✅ Deployment finished.'
        }
    }
}
