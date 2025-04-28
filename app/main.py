from fastapi import FastAPI
from fastapi.responses import JSONResponse
from datetime import datetime
import os

app = FastAPI()

# 배포 시간을 저장할 파일 경로
DEPLOY_TIME_FILE = "/app/deploy_time.txt"

def get_deploy_time():
    """배포 시간을 파일에서 읽어오거나 새로 생성"""
    if not os.path.exists(DEPLOY_TIME_FILE):
        # 파일이 없으면 현재 시간을 저장
        deploy_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        with open(DEPLOY_TIME_FILE, "w") as f:
            f.write(deploy_time)
        return deploy_time
    else:
        # 파일이 있으면 저장된 시간을 읽어옴
        with open(DEPLOY_TIME_FILE, "r") as f:
            return f.read().strip()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/hello")
async def hello():
    deploy_time = get_deploy_time()
    return {
        "message": "Hello from FastAPI",
        "deployed_at": deploy_time,
        "current_time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

@app.get("/health")
async def health_check():
    return JSONResponse(
        status_code=200,
        content={"status": "healthy"}
    ) 