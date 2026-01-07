#!/bin/bash
# user-data.sh — EC2 launch script for Node.js app

# Log everything
exec > >(tee /var/log/user-data.log) 2>&1

echo "🚀 Starting EC2 initialization..."

# Update system
yum update -y

# Install Node.js 18 (Amazon Linux 2)
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install git (optional, if pulling code from GitHub)
yum install -y git

# Create app directory
mkdir -p /opt/myapp
cd /opt/myapp

# OPTION 1: Clone your app (replace with your repo)
# git clone https://github.com/youruser/your-repo.git /opt/myapp

# OPTION 2: For demo, create a simple server (replace in real use)
cat > server.mjs << 'EOF'
import http from 'node:http';

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from Node.js on EC2! DB: ${db_host}\n');
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Listening on 0.0.0.0:3000');
});
EOF

# Create .env from Terraform variables (insecure but matches your design)
cat > .env << EOF
DB_HOST=${db_host}
DB_NAME=${db_name}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
EOF

# Install dependencies (if you had a package.json, you'd do this)
# npm install

# Allow port 3000 (optional; better done via Security Group)
# iptables not used on AL2; rely on SGs instead

# Start app (in background)
nohup node server.mjs > app.log 2>&1 &

echo "✅ EC2 setup complete. App running on port 3000."