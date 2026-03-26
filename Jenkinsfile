pipeline {
    agent { label 'ec2-agent' }

    environment {
        AWS_REGION = credentials('AWS_REGION_NAME')
        ACCOUNT_ID = credentials('AWS_ACCOUNT_ID')
        ECR_REPO   = "nodejs-jenkins-cicd"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        IMAGE_URI  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/CS-admin-hub/nodejs-golden-cicd.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'   // installs devDependencies too (needed for jest/eslint)
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $ECR_REPO:$IMAGE_TAG .'
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS \
                      --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Tag & Push') {
            steps {
                sh 'docker tag $ECR_REPO:$IMAGE_TAG $IMAGE_URI'
                sh 'docker push $IMAGE_URI'
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker image prune -f'
            }
        }
    }

    post {
        success { echo "✅ Pushed: ${IMAGE_URI}" }
        failure { echo "❌ Pipeline failed — check logs" }
    }
}
