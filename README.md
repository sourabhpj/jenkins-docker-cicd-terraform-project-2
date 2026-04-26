# jenkins-cicd-2
Multi-server CI/CD Automation: Jenkins,Docker & AWS (Two-Tier Architecture).
## Project Documentation: Multi-Server CI/CD Automation

# 1. Architectural Overview
Instead of doing everything on one machine, we used a Two-Tier Architecture to ensure the deployment process is professional and scalable.
**Instance 1 (Jenkins Server)**: Acts as the Automation Engine. It pulls code from GitHub and manages the deployment workflow.
**Instance 2 (App Server)**: Acts as the Production Environment. This is where Docker runs the actual website.

**2. Step-by-Step Execution**
Stage 1: Source Code Management (GitHub)
We maintained two essential files in the GitHub repository: index.html (the content) and Dockerfile (the instructions).
We verified the branch was set to main so Jenkins could find the code.
Stage 2: Continuous Integration (Jenkins Server)
Checkout: Jenkins connected to GitHub and cloned the repository into its local workspace.
SSH Authentication: We used an SSH Agent with a stored credential (serverskey) to securely talk to the App Server without using passwords.
Stage 3: Continuous Deployment (App Server via SCP & SSH)
File Transfer (SCP): Jenkins pushed the Dockerfile and index.html from its workspace to the /home/ubuntu/ directory of the App Server.
Docker Build: On the App Server, we triggered a command to build a custom Docker image named my-custom-app.
Container Refresh: We used a command to stop and remove any old version of the container (my-web-app-final) before starting the new one to avoid port conflicts.

**3. Challenges & Solutions**
<table>
   Problem      Root Cause      Solution
No such file or directory Jenkins was looking for files before cloning the repo. Added a Checkout stage to pull code from GitHub first.
Parse Error on Line 3 Extra text (index.html) was present inside the Dockerfile. Cleaned the Dockerfile to only include valid instructions like FROM, COPY, and EXPOSE.
Deployment Success Default Nginx page was still showing. Re-built the image with the fixed COPY command to include the custom HTML.
</table>
**4. Final Achievement**
​The website is successfully running on the App Server (52.66.97.147) on Port 80, showing the custom message: "Good morning from shankeshwar platina. i am sourabh".






**Project Overview: Multi-Server CI/CD Automation**
​This project demonstrates a professional DevOps workflow where we separated the Automation Logic (Jenkins) from the Application Runtime (Docker).
​
** ​1. Server Architecture**
 Server Name         Role                IP Address                  Key Tools Installed
Jenkins-Server      CI/CD Controller       13.206.120.242            Jenkins, Git, SSH-Agent
App-Server          Production Host         52.66.97.147             Docker, Nginx (via Docker)


2. Step-by-Step Flow & Commands
Step A: GitHub Setup (Source Code)
We pushed two files to the repository sourabhpj/jenkins-cicd-2.git:

index.html: The custom website content.

Dockerfile: The blueprint for the container.
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80

Step B: The Jenkins Pipeline (Automation)
When you clicked Build Now, Jenkins executed these commands internally:

Stage 1: Checkout
Jenkins downloaded the code from GitHub into its own workspace.
git branch: 'main', url: 'https://github.com/sourabhpj/jenkins-cicd-2.git'

Stage 2: File Transfer (SCP)
Using the SSH Agent (serverskey), Jenkins copied the files to the App-Server.
scp -o StrictHostKeyChecking=no Dockerfile index.html ubuntu@52.66.97.147:/home/ubuntu/

Stage 3: Deployment (SSH & Docker)
Jenkins logged into the App-Server via SSH and ran the following commands:

1. Move to home directory: cd /home/ubuntu
2. Build the Image:
sudo docker build -t my-custom-app .
3. Stop old version:
sudo docker rm -f my-web-app-final || true
4.Run the new version:
sudo docker run -d -p 80:80 --name my-web-app-final my-custom-app

3. Key Troubleshooting Steps
During the project, we encountered and solved these critical issues:

Workspace Error: The initial build failed because Jenkins had an empty workspace. We solved this by adding the Checkout stage.

Dockerfile Syntax: A "Parse Error" occurred because of extra text on Line 3. We cleaned the file to only include standard Docker instructions.

Memory Management: Since we used t3.micro instances, we monitored the instances to prevent crashes.

4. The Final Outcome
The pipeline successfully completed Build #21. Browsing to http://52.66.97.147/ now displays:

"Good morning from shankeshwar platina. i am sourabh"
