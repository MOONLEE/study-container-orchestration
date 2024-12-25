# Use the official Node.js image
FROM node:18-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY package.json server.js ./

# Install dependencies
RUN npm install

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
