# Genesis/docker/Dockerfile로 빌드 (version 0.3.5 기준)
FROM genesis:0.3.5

RUN apt update && apt install -y \
    vim \
    # RTX50 시리즈에서 libGLU.so.1 의존성 해결을 위해 추가
    libglu1-mesa \
    libgl1-mesa-glx \
    libegl1-mesa \
    libgles2-mesa-dev \
    # git ssh 접속을 위한 패키지
    openssh-client \
    # dynamic linker가 새로 설치된 라이브러리를 인식하도록 설정
    && ldconfig \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip setuptools \
    # RTX50 시리즈에서 torch 버전 호환을 위해 기존 torch 패키지 제거 후 재설치
    && pip uninstall -y torch torchvision torchaudio \
    && pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu129 \
    # 기타 개발 도구 및 python 패키지 설치
    && pip install \
    black \
    isort \
    # genesis 예제 실행에 필요한 패키지들
    rsl-rl-lib==2.2.4 \
    tensorboard==2.20.0

ENTRYPOINT ["/entrypoint.sh"]