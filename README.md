
# Project Title

A brief description of what this project does and who it's for


# 🎨 Custom Photo QR Generator

This is a Streamlit application that allows users to create customizable QR codes with the option of adding overlaying photos in the background and still getting an easily-recognized QR code. Most free tools online limit your ability to change shapes or add logos or at least hides it behind a paywall or a free trial; this project aims to provide that flexibility for free while maintaining high-quality output.

  
## 🧠 The Learning Journey (Why this matters)


This project's aim was a mix of  interest in QR code beautification in  python and a desire to apply Docker best practices I learnt with guidance from the Project "[Container Best Practices](https://devopsroadmap.io/projects/container-best-practices/)" in the Dynamic DevOps Roadmap.

* **Modern Package Management:** Switched to **`uv`** by Astral. I chose this because it is significantly faster than `pip` and provides a `uv.lock` file for 100% reproducible environments and more reusable than `requirement.txt` files.

* **Efficient Containerization:** I optimized my `Dockerfile` with Docker Best Practices in mind.


## 🛠️ Tech Stack


* **Core Logic:** [Segno](https://github.com/heuer/segno) (QR generation), [Pillow](https://www.google.com/search?q=https://python-pillow.org/) (Image processing).
* **Front-end:** [Streamlit](https://streamlit.io/).
- **Dependency Management**:  [uv](https://github.com/astral-sh/uv)
* **DevOps:** [Docker](https://www.docker.com/).



 
## 🚀 Running the App

  
### Prerequisites

  You just need to have Docker installed on your system.


 1. **Run the Container:**
The image currently resides on Dockerhub registry.

```bash

docker run --rm -d -p 8501:8501/tcp menna011/custom-qr-app:2.0

```
2. **View the App:** Open `http://127.0.0.1:8501` in your browser.

## ⏭️ Applied Best Practices

* Essential Practices
    * Use Dockerfile linter 🟢
    * Check Docker language specific best practices 🟢
    * Create a single application per Docker image 🟢
    * Create configurable ephemeral containers 🟢

* Image Practices
    * Use optimal base image 🟢
    * Pin versions everywhere 🟢
    * Create image with the optimal size 🟡
    * Use multi-stage whenever possible 🟢
    * Avoid any unnecessary files 🟡

* Security Practices
    * Always use trusted images 🟢
    * Never use untrusted resources 🟢
    * Never store sensitive data in the image 🟢
    * Use a non-root user 🟢
    * Scan image vulnerabilities 🟢 (Trivy)

* Misc Practices
    * Leverage Docker build cache 🟢
    * Avoid system cache 🟢
    * Create a unified image across envs 🟡
    * Use ENTRYPOINT with CMD 🟢
  
## 🚀 Learned lessons and what I would do differently in future Projects
-   **Automated CI/CD Pipeline:** Instead of manual building, I would set up GitHub Actions or Jenkins. Every time I push code, the image would be automatically built, scanned for vulnerabilities, and pushed to the registry.
    
- **Package Management Issues**: Packages using entry-point plugins (like qrcode-artistic for this project) must be explicitly declared in pyproject.toml and correctly registered in the .venv inside the image to be recognized by the main library.

- **Using the Official Docker**: I Diagnosed and resolved "Permission Denied" errors caused by the Snap version of Docker's security confinement, and therefore installed the official docker, which made working with docker better.

-   **Secret Management:** Right now, the app is simple, but if I added a database or API keys, I would move away from `ENV` variables in the Dockerfile and use a secure secret manager or `.dockerignore` combined with encrypted secrets.

- **Deploying app to the cloud**: This time, I didn't have the time or resources to deploy the app onto the cloud, so I'd like to try doing that in the near future whether it's this app or another one.   
