# 🟢 Jenkins CI/CD Pipeline — Node.js App to AWS ECR

Automated pipeline that lints, tests, builds a Docker image, and pushes it to AWS ECR on every `git push`.

---

## 🏗️ Pipeline Flow
```
GitHub Push → Webhook → Jenkins Controller (EC2) → Jenkins Agent (EC2) → Lint → Test → Docker Build → Push to ECR
```

---

## 🖥️ Infrastructure

> ✅ **Recommended:** Run Jenkins controller and agent on **separate EC2 instances**.
> The controller only orchestrates — all actual build work runs on the agent.

| Component | Instance | Role |
|---|---|---|
| Jenkins Controller | EC2 #1 | Jenkins UI, job scheduling, webhook receiver |
| Jenkins Agent | EC2 #2 | Runs pipeline — lint, test, build, push |
| AWS ECR | AWS Managed | Stores Docker images |
| GitHub | Git Remote | Source code + webhook trigger |

---

## 📋 Prerequisites

### AWS
- [ ] Two EC2 instances launched (Amazon Linux 2023 recommended)
- [ ] Security group on **Controller EC2**: ports `8080` and `22` open
- [ ] Security group on **Agent EC2**: port `22` open
- [ ] ECR repository created: `nodejs-golden-cicd`
- [ ] IAM Role with ECR permissions attached to **Agent EC2**

### Controller EC2 — Install Jenkins
```bash
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins java-17-amazon-corretto
sudo systemctl start jenkins && sudo systemctl enable jenkins
```
Access Jenkins at: `http://<CONTROLLER_IP>:8080`

### Agent EC2 — Install Required Tools
```bash
sudo yum update -y

# Java (required for Jenkins agent)
sudo yum install -y java-17-amazon-corretto

# Node.js 20
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs

# Docker
sudo yum install -y docker
sudo systemctl start docker && sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Verify all tools
node --version && npm --version && docker --version && aws --version && java -version
```

---

## ⚙️ Setup Steps

### 1. Connect Agent to Jenkins Controller
```
Jenkins UI → Manage Jenkins → Nodes → New Node
→ Node name: ec2-agent
→ Type: Permanent Agent
→ Remote root directory: /home/ec2-user
→ Label: ec2-agent
→ Launch method: Launch agents via SSH
→ Host: <AGENT_EC2_PRIVATE_IP>
→ Credentials: Add SSH private key of agent EC2
→ Save
```
Verify the agent shows **ONLINE** in `Manage Jenkins → Nodes`.

### 2. IAM Role for Agent EC2
Attach a role with `AmazonEC2ContainerRegistryPowerUser` to the **agent EC2**:
```
AWS Console → EC2 → Agent Instance → Actions → Security → Modify IAM Role
```

### 3. Jenkins Credentials
Never hardcode AWS details in Jenkinsfile. Store as secrets:
```
Manage Jenkins → Credentials → Global → Add Credentials → Secret text
```
| ID | Value |
|---|---|
| `AWS_ACCOUNT_ID` | your 12-digit AWS account ID |
| `AWS_REGION_NAME` | `us-east-1` |

> ✅ Jenkins automatically masks these values as `****` in all build logs.

### 4. Jenkinsfile
```groovy
pipeline {
    agent { label 'ec2-agent' }

    environment {
        AWS_REGION = credentials('AWS_REGION_NAME')
        ACCOUNT_ID = credentials('AWS_ACCOUNT_ID')
        ECR_REPO   = "nodejs-golden-cicd"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        IMAGE_URI  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_ORG/nodejs-cicd-jenkins.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
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
```

### 5. GitHub Webhook (Auto-trigger)
```
GitHub Repo → Settings → Webhooks → Add webhook
  Payload URL:  http://<CONTROLLER_IP>:8080/github-webhook/
  Content type: application/json
  Event:        Just the push event
```
Enable trigger in Jenkins job:
```
Job → Configure → Build Triggers
→ ✅ GitHub hook trigger for GITScm polling → Save
```

---

## 🐳 Dockerfile
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY src/ ./src/
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "src/index.js"]
```
> `--only=production` excludes devDependencies (jest, eslint, nodemon) from the final image — keeps it lean.

---

## 🐛 Common Issues & Fixes

| Error | Fix |
|---|---|
| `npm: command not found` | Install Node.js 20 on agent — see Prerequisites above |
| Lint fails — unused variable | Prefix unused args with `_` e.g. `_next` instead of `next` |
| Agent offline | Check `/tmp` disk: `df -h /tmp` — clear if full |
| Docker permission denied | `sudo usermod -aG docker jenkins && sudo systemctl restart jenkins` |
| ECR login fails | Verify IAM role is attached to **agent** EC2 |
| `ERROR: AWS_ACCOUNT_ID` | Credential ID must exactly match Jenkins (case-sensitive) |
| Webhook delivers ✅ but no build | Enable "GitHub hook trigger" in Job → Configure → Build Triggers |
| Plugin toggle unclickable | `cd /var/lib/jenkins/plugins && sudo rm -f github.jpi.disabled && sudo systemctl restart jenkins` |

---

## 📁 Repository Structure
```
nodejs-cicd-jenkins/
├── src/
│   └── index.js
├── tests/
├── Dockerfile
├── Jenkinsfile
├── jest.config.js
├── package.json
├── package-lock.json
└── README.md
```
