FROM perl:5.38

RUN apt-get update && \
    apt-get install -y ttyd dos2unix procps nano && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app
RUN find /app -type f -name "*.pl" -exec dos2unix {} \; || true

CMD ["ttyd", "-p", "8080", "-i", "0.0.0.0", "-c", "admin:perl123", "bash", "--login"]
