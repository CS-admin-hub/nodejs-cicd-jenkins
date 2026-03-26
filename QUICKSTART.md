# ⚡ Quick Start - Node.js Edition

## 🎯 What You Have

Production-ready Node.js Express API with:
- ✅ Express.js REST API
- ✅ Jest test suite (3 tests)
- ✅ Docker containerization
- ✅ GitHub Actions CI/CD
- ✅ Docker Hub integration
- ✅ ESLint code quality
- ✅ Health monitoring endpoint

## 🚀 Test Locally (3 Options)

### Option 1: With Node.js

```bash
# Install dependencies
npm install

# Run tests
npm test

# Start server
npm start

# Test endpoints
curl http://localhost:3000/
curl http://localhost:3000/health
```

### Option 2: With Docker

```bash
# Build and run
docker build -t golden-cicd-nodejs .
docker run -d --name test-app -p 3000:3000 golden-cicd-nodejs

# Test
curl http://localhost:3000/health

# Cleanup
docker stop test-app && docker rm test-app
```

### Option 3: Use Test Script

```bash
test-local.bat
```

## 📦 Push to GitHub

### 1. Create Repository

Visit: https://github.com/new
- Name: `golden-cicd-nodejs`
- Public repository

### 2. Add Docker Hub Secrets

Go to: Repository Settings → Secrets → Actions

Add:
- `DOCKERHUB_USERNAME` = `ninad04`
- `DOCKERHUB_TOKEN` = `<your-docker-hub-token>`

Get token from: https://hub.docker.com/settings/security

### 3. Push Code

```bash
git init
git add .
git commit -m "Initial commit: Node.js CI/CD template"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/golden-cicd-nodejs.git
git push -u origin main
```

## 🐳 Docker Hub

After pushing, your image will be at:
```
docker pull ninad04/golden-cicd-nodejs:latest
docker run -d -p 3000:3000 ninad04/golden-cicd-nodejs:latest
```

## 📊 API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check with uptime

## 🧪 Tests

3 tests covering:
- ✅ Root endpoint returns correct JSON
- ✅ Health endpoint returns status OK
- ✅ 404 handler for unknown routes

## 🎯 Key Differences from Python Version

| Feature | Python (FastAPI) | Node.js (Express) |
|---------|------------------|-------------------|
| Runtime | Python 3.11 | Node.js 20 |
| Framework | FastAPI | Express.js |
| Testing | pytest | Jest + Supertest |
| Port | 8000 | 3000 |
| Image Size | ~150MB | ~120MB |
| Auto Docs | /docs (Swagger) | Manual setup |

## 📝 Project Structure

```
golden-cicd-nodejs/
├── src/index.js          # Express app
├── tests/api.test.js     # Jest tests
├── Dockerfile            # Container config
├── package.json          # Dependencies
└── .github/workflows/    # CI/CD pipeline
```

## ✅ Success Checklist

- [ ] Tests pass locally (`npm test`)
- [ ] Docker image builds
- [ ] Container runs successfully
- [ ] Health endpoint returns 200
- [ ] GitHub repository created
- [ ] Docker Hub secrets added
- [ ] CI/CD pipeline passes
- [ ] Image pushed to Docker Hub

---

**Ready to deploy!** 🚀
