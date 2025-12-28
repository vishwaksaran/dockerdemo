# How to Run

This repository handles both a Legacy Angular application (Node 14) and a Modern React application (Node 20+) using Docker.

## 1. Production Mode (What you run on servers)
This builds the Angular app using Node 14 and the React app using Node 20, then serves them both via Nginx.

```bash
# Build and run the production environment
docker-compose up --build production
```

- **React App**: [http://localhost/](http://localhost/)
- **Angular App**: [http://localhost/legacy](http://localhost/legacy)

## 2. Local Development (Working on code)
You can run the stack in development mode where files are watched.

### Run React Only (Modern Dev)
```bash
docker-compose up --build dev-react
```
- URL: [http://localhost:8080](http://localhost:8080)

### Run Angular Only (Legacy Maintenance)
```bash
docker-compose up --build dev-angular
```
- URL: [http://localhost:8081](http://localhost:8081)

## 3. Deployment Environments
Since the output is just a standard Nginx container, you can deploy this Docker image to any environment (QA/Stage/Prod) by updating the `command` or simply running the container as is.

The builds happen **inside** the Docker container, so the version of Node.js on your CI/CD runner or laptop does not matter.
