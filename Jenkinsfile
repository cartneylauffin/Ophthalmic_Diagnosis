pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/cartneylauffin/Ophthalmic_Diagnosis.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("cartney/ophthalmic-diagnosis")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop old container if exists
                    sh 'docker stop ophthalmic-app || true'
                    sh 'docker rm ophthalmic-app || true'

                    // Run new container
                    sh 'docker run -d -p 8501:8501 --name ophthalmic-app cartney/ophthalmic-diagnosis'
                }
            }
        }
    }
}
