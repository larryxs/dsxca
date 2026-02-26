FROM perl:5.38   # full versiyon, perl garanti yüklü

# ttyd'yi binary olarak indir (apt olmadan)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget && \
    wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd && \
    apt-get purge -y wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Diğer faydalı araçlar (isteğe bağlı, ama procps nano faydalı)
RUN apt-get update && \
    apt-get install -y procps nano dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . /app

# CRLF düzelt (dos2unix varsa)
RUN find /app -type f -name "*.pl" -exec dos2unix {} \; || true

# ttyd'yi başlat + PATH garanti + login shell
CMD ["/bin/sh", "-c", "export PATH=/usr/local/bin:/usr/bin:/bin:$PATH && exec ttyd -p 8080 -i 0.0.0.0 -c admin:perl123 bash --login"]
