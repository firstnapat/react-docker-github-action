# Stage 1: Build the application
FROM node:18 as builder

WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code to the container
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create the production image
FROM node:18-alpine

WORKDIR /app

# Install serve globally to run the application
RUN npm install -g serve

# Copy the built application from the builder stage
COPY --from=builder /app/dist ./dist

# Expose the port the application will be listening on
EXPOSE 3000

# Start the application
CMD [ "npx", "serve", "-s", "dist" ]
