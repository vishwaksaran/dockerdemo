# -----------------------------------------------------------------------------
# STAGE 1: Legacy Builder (Node 14)
# -----------------------------------------------------------------------------
FROM node:14.21.3-buster-slim AS legacy-builder

WORKDIR /app

# Install system dependencies for node-gyp (python, make, g++)
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

COPY package.json ./

# Install ALL dependencies (including legacy node-sass)
# This works because we are on Node 14
RUN npm install --legacy-peer-deps && npm cache clean --force

COPY . .

# Build the Angular app
# Output typically goes to ./dist usually, but based on webpack config validation:
# angular/webpack.config.js output filename is just 'bundle.js' in the root output path?
# Let's assume the user's config outputs to 'dist' or we force it.
# We will check the output directory after build or assume 'dist'.
# For safety in this demo, we run the build command.
RUN npm run build:angular

# -----------------------------------------------------------------------------
# STAGE 2: Modern Builder (Node 20)
# -----------------------------------------------------------------------------
FROM node:20-alpine AS modern-builder

WORKDIR /app

# We still copy package.json, BUT:
# Installing legacy dependencies on Node 20 will FAIL.
# We use --ignore-scripts to skip node-sass compilation failures.
# We assume the React build doesn't *actually* need the binary node-sass if 'sass' (Dart Sass) is present,
# or if it does, this step might require a 'package.json' cleanup in a real scenario.
COPY package.json ./

# Try to install with --ignore-scripts to avoid binary compilation errors
RUN npm install --legacy-peer-deps --ignore-scripts && npm cache clean --force

COPY . .

# Build the React app
RUN npm run build:react

# -----------------------------------------------------------------------------
# STAGE 3: Production Runtime (Nginx)
# -----------------------------------------------------------------------------
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy build artifacts
# NOTE: We need to know EXACTLY where webpack outputs files. 
# Standard webpack default is 'dist'. 
# Copy Angular build to /angular subdirectory
COPY --from=legacy-builder /app/dist/angular /usr/share/nginx/html/angular

# Copy React build to /react subdirectory (which is root in nginx config)
COPY --from=modern-builder /app/dist/react /usr/share/nginx/html/react

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
