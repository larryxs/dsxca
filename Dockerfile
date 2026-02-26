FROM perl:5.38   # slim yerine FULL perl image'ı – perl yolu garanti /usr/local/bin/perl

RUN apt-get update && \
    apt-get install -y \
      ttyd \
      dos2unix \
      procps \
      nano vim-tiny \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Build sırasında perl'ün çalıştığını test et (Actions log'unda göreceksin)
RUN perl -v && \
    which perl && \
    ls -la /usr/local/bin/perl && \
    echo "Perl path OK" && \
    perl -e 'print "Perl çalışıyor\n"'

WORKDIR /app

# Eğer repo'da .pl dosyaların varsa kopyala + CRLF → LF otomatik düzelt
COPY . /app
RUN find /app -type f -name "*.pl" -exec dos2unix {} \; || true

# ttyd'yi başlatırken PATH'i zorla + login shell
CMD ["/bin/sh", "-c", "export PATH=/usr/local/bin:/usr/bin:/bin:$PATH && exec ttyd -p 8080 -i 0.0.0.0 -c admin:perl123 bash --login"]
