# Start from KiCad 9.0 base image, which has KiCad CLI, Python 3, and related KiCad requirements
FROM ghcr.io/kicad/kicad:9.0

USER root

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install core tools, Node.js, Java, Cargo/Rust, cc65 (Git master), and build dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        make \
        git \
        librsvg2-bin \
        build-essential \
        ca-certificates \
        gnupg \
        unzip && \
    # Install Node.js 20.x \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g bun && \
    # Install JDK 25 to run Freerouting v2.2.4+
    wget -q https://corretto.aws/downloads/latest/amazon-corretto-25-x64-linux-jdk.tar.gz -O /tmp/jdk25.tar.gz && \
    mkdir -p /usr/local/lib/jvm && \
    tar -xzf /tmp/jdk25.tar.gz -C /usr/local/lib/jvm && \
    rm /tmp/jdk25.tar.gz && \
    ln -sf /usr/local/lib/jvm/amazon-corretto-25*/bin/java /usr/local/bin/java && \
    # Install Freerouting
    wget -q "https://github.com/freerouting/freerouting/releases/download/v2.2.4/freerouting-2.2.4.jar" -O /usr/local/lib/freerouting.jar && \
    # Install Cargo and Galette (for PLD compilation) \
    apt-get install -y --no-install-recommends cargo && \
    cargo install galette --version 0.3.0 --root /usr/local --locked && \
    # Build latest cc65 toolchain (ca65, ld65) from GitHub master branch
    git clone https://github.com/cc65/cc65.git /tmp/cc65 && \
    make -C /tmp/cc65 -j$(nproc) && \
    make -C /tmp/cc65 install PREFIX=/usr/local && \
    rm -rf /tmp/cc65 && \
    # Compile 7800sign utility
    curl -fsSL https://raw.githubusercontent.com/7800-devtools/7800basic/master/7800sign.c -o /tmp/7800sign.c && \
    gcc -O2 /tmp/7800sign.c -o /usr/local/bin/7800sign && \
    rm /tmp/7800sign.c && \
    # Clean up apt
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up global environment variables
ENV FREEROUTING_JAR=/usr/local/lib/freerouting.jar
