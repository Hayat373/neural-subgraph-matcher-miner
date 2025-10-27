FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# ---- System deps ----
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    git \
    build-essential \
    python3.8 \
    python3.8-dev \
    python3.8-distutils \
    python3-scipy \
    libfreetype6-dev \
    libpng-dev \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- Install pip for Python 3.8 ----
RUN curl -sS https://bootstrap.pypa.io/pip/3.8/get-pip.py -o get-pip.py \
    && python3.8 get-pip.py \
    && rm get-pip.py

# ---- Make python / pip default ----
RUN ln -sf /usr/bin/python3.8 /usr/bin/python && \
    ln -sf /usr/local/bin/pip /usr/bin/pip

WORKDIR /app
COPY requirements.txt .

# ---- Install compatible versions ----
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir numpy==1.19.5 \
 && pip install --no-cache-dir matplotlib==3.3.4 scikit-learn==1.0.2 seaborn==0.11.2 \
 && pip install torch==1.8.0+cpu torchvision==0.9.0+cpu torchaudio==0.8.0 \
        -f https://download.pytorch.org/whl/torch_stable.html \
 && pip install torch-geometric==2.0.4 \
 && pip install deepsnap==0.2.0 networkx==2.6 test-tube==0.7.5 tqdm==4.43.0

RUN pip freeze | grep numpy

COPY . .

CMD ["python", "--version"]
