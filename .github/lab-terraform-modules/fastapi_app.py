from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI()

# 배포 시각을 저장할 파일 경로
DEPLOY_TIME_FILE = "/root/app/deploy_time.txt"

# 배포 시각을 파일에 저장
def save_deploy_time():
    deploy_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(DEPLOY_TIME_FILE, "w") as f:
        f.write(deploy_time)

# 배포 시각을 파일에서 읽기
def get_deploy_time():
    if os.path.exists(DEPLOY_TIME_FILE):
        with open(DEPLOY_TIME_FILE, "r") as f:
            return f.read().strip()
    return "Deploy time not found"

# 서버 시작 시 배포 시각 저장
save_deploy_time()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/hello")
def read_hello():
    deploy_time = get_deploy_time()
    return {
        "message": "Hello from FastAPI!",
        "deploy_time": deploy_time,
        "current_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    } 