# 🚀 Node.js CI/CD Template - Complete Guide

## 📦 What This Application Does

This is a **production-ready Node.js REST API** built with Express.js that includes:

### Core Features:
- ✅ **Express.js REST API** - Lightweight web framework
- ✅ **Health Monitoring** - `/health` endpoint with uptime tracking
- ✅ **Automated Testing** - Jest test suite with 3 tests
- ✅ **Docker Support** - Containerized for consistent deployment
- ✅ **CI/CD Pipeline** - Automated testing and deployment via GitHub Actions
- ✅ **Docker Hub Integration** - Automatic image publishing
- ✅ **Code Quality** - ESLint for code standards

### API Endpoints:
1. **GET /** - Returns welcome message with environment info
2. **GET /health** - Returns health status, uptime, and timestamp

---

## 🧪 How to Test This Application

### Method 1: Test with Node.js (Local Development)

```bash
# 1. Install dependencies
npm install

# 2. Run tests
npm test

# Expected output:
# PASS tests/api.test.js
#   ✓ GET / returns welcome message
#   ✓ GET /health returns health status  
#   ✓ GET /nonexistent returns 404

# 3. Start the server
npm start

# 4. Test endpoints (in another terminal)
curl http://localhost:3000/
# Returns: {"message":"Welcome to Golden CI/CD Node.js API","environment":"local","version":"1.0.0"}

curl http://localhost:3000/health
# Returns: {"status":"OK","environment":"local","uptime":5.123,"timestamp":"2026-02-20T..."}
```

### Method 2: Test with Docker

```bash
# 1. Build Docker image
docker build -t golden-cicd-nodejs .

# 2. Run container
docker run -d --name test-app -p 3000:3000 -e APP_ENV=local golden-cicd-nodejs

# 3. Test it
curl http://localhost:3000/health

# 4. View logs
docker logs test-app

# 5. Stop and remove
docker stop test-app
docker rm test-app
```

### Method 3: Use Automated Test Script

```bash
# Windows
test-local.bat

# This script will:
# - Build Docker image
# - Start container
# - Test both endpoints
# - Show logs
# - Wait for you to press a key
# - Clean up automatically
```

---

## 🎯 What Makes This Production-Ready?

### 1. Comprehensive Testing
- Unit tests for all endpoints
- Integration tests with supertest
- Health check validation
- 404 error handling tests

### 2. Docker Optimization
- Uses Alpine Linux (smaller image ~120MB)
- Multi-stage build potential
- Production dependencies only
- Proper port exposure

### 3. CI/CD Automation
- Runs tests on every push
- Builds Docker image
- Verifies health endpoint
- Pushes to Docker Hub automatically
- Fails fast if tests don't pass

### 4. Monitoring & Health Checks
- `/health` endpoint for load balancers
- Uptime tracking
- Environment information
- Timestamp for debugging

### 5. Code Quality
- ESLint configuration
- Consistent code style
- Error handling
- 404 handling

---

## 📊 Test Results You Should See

### When running `npm test`:
```
PASS tests/api.test.js
  API Endpoints
    GET /
      ✓ should return welcome message (25ms)
    GET /health
      ✓ should return health status (10ms)
    GET /nonexistent
      ✓ should return 404 for unknown routes (8ms)

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
```

### When testing `/health` endpoint:
```json
{
  "status": "OK",
  "environment": "local",
  "uptime": 12.456,
  "timestamp": "2026-02-20T05:30:00.000Z"
}
```

### When testing `/` endpoint:
```json
{
  "message": "Welcome to Golden CI/CD Node.js API",
  "environment": "local",
  "version": "1.0.0"
}
```

---

## 🚀 Push to GitHub (After Testing Locally)

### Step 1: Initialize Git
```bash
git init
git add .
git commit -m "Initial commit: Node.js Express API with CI/CD"
git branch -M main
```

### Step 2: Create GitHub Repository
Go to: https://github.com/new
- Name: `golden-cicd-nodejs`
- Public repository
- Don't initialize with anything

### Step 3: Add Docker Hub Secrets
Go to: Repository Settings → Secrets → Actions

Add these secrets:
- `DOCKERHUB_USERNAME` = `ninad04`
- `DOCKERHUB_TOKEN` = Get from https://hub.docker.com/settings/security

### Step 4: Push Code
```bash
git remote add origin https://github.com/YOUR_USERNAME/golden-cicd-nodejs.git
git push -u origin main
```

### Step 5: Watch CI/CD Run
- Go to Actions tab
- Watch tests run
- See Docker image build
- Verify push to Docker Hub

---

## 🐳 After CI/CD Completes

Your image will be available on Docker Hub:

```bash
# Pull from anywhere
docker pull ninad04/golden-cicd-nodejs:latest

# Run it
docker run -d -p 3000:3000 ninad04/golden-cicd-nodejs:latest

# Test it
curl http://localhost:3000/health
```

---

## 📁 Project Structure Explained

```
golden-cicd-nodejs/
├── src/
│   └── index.js              # Main Express application
│                             # - Defines routes (/, /health)
│                             # - Error handling
│                             # - Server startup
│
├── tests/
│   └── api.test.js           # Jest tests
│                             # - Tests all endpoints
│                             # - Uses supertest for HTTP testing
│
├── .github/workflows/
│   └── ci-cd.yml             # GitHub Actions pipeline
│                             # - Runs on push to main
│                             # - Tests → Build → Push to Docker Hub
│
├── Dockerfile                # Container configuration
│                             # - Node.js 20 Alpine
│                             # - Installs dependencies
│                             # - Exposes port 3000
│
├── package.json              # Dependencies and scripts
│                             # - express: Web framework
│                             # - jest: Testing
│                             # - supertest: HTTP testing
│
├── jest.config.js            # Jest configuration
├── .eslintrc.json            # Code quality rules
└── .env.example              # Environment variables template
```

---

## 🔍 Key Differences: Node.js vs Python Version

| Feature | Python (FastAPI) | Node.js (Express) |
|---------|------------------|-------------------|
| **Runtime** | Python 3.11 | Node.js 20 |
| **Framework** | FastAPI | Express.js |
| **Testing** | pytest | Jest + Supertest |
| **Port** | 8000 | 3000 |
| **Image Size** | ~150MB | ~120MB |
| **Auto Docs** | Yes (/docs) | No (manual) |
| **Async** | Native async/await | Callback/Promise based |
| **Speed** | Very fast | Very fast |
| **Use Case** | Data APIs, ML | Web apps, APIs |

---

## ✅ Success Checklist

Test locally:
- [ ] `npm install` completes without errors
- [ ] `npm test` shows 3 tests passing
- [ ] `npm start` starts server on port 3000
- [ ] `curl http://localhost:3000/` returns JSON
- [ ] `curl http://localhost:3000/health` returns status OK

Test with Docker:
- [ ] `docker build` completes successfully
- [ ] `docker run` starts container
- [ ] Health endpoint accessible
- [ ] Logs show "Server running on port 3000"

Push to GitHub:
- [ ] Repository created
- [ ] Docker Hub secrets added
- [ ] Code pushed successfully
- [ ] CI/CD pipeline passes
- [ ] Image appears on Docker Hub

---

## 🎯 What This Template Provides

1. **Ready-to-use REST API** - Just add your endpoints
2. **Automated testing** - Tests run on every push
3. **Docker containerization** - Deploy anywhere
4. **CI/CD pipeline** - Fully automated
5. **Production best practices** - Error handling, health checks, logging
6. **Docker Hub integration** - Automatic image publishing
7. **Clean code structure** - Easy to understand and extend

---

## 🚀 Next Steps After Setup

1. **Add more endpoints** - Edit `src/index.js`
2. **Add more tests** - Edit `tests/api.test.js`
3. **Customize** - Add database, authentication, etc.
4. **Deploy** - Use Docker image on any cloud platform
5. **Monitor** - Use `/health` endpoint for monitoring

---

**This is a complete, production-ready template. Test it locally, push to GitHub, and it's ready to deploy!** 🎉
