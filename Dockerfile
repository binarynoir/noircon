FROM alpine:latest

# Upgrade all installed packages and install necessary packages
RUN apk upgrade && \
    apk add --no-cache bash coreutils jq openssl curl

# Set the working directory
WORKDIR /app

# Fetch the latest release tar.gz from GitHub
RUN curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/binarynoir/noircon/releases/latest | \
    jq -r '.tarball_url' | \
    xargs curl -L -o /tmp/noircon.tar.gz

# Create the temporary directory and extract the tarball
RUN mkdir -p /tmp/noircon && \
    tar -xzf /tmp/noircon.tar.gz -C /tmp/noircon --strip-components=1

# Copy the noircon script to /usr/local/bin
RUN cp /tmp/noircon/noircon /usr/local/bin/noircon

# Copy the man page to the appropriate location
RUN mkdir -p /usr/share/man/man1 && \
    cp /tmp/noircon/noircon.1 /usr/share/man/man1/noircon.1

# Clean up the temporary files
RUN rm -rf /tmp/noircon /tmp/noircon.tar.gz

# Make the script executable
RUN chmod +x /usr/local/bin/noircon

# Run noircon --init during the build process
ENV NOIRCON_CONFIG="/app/noircon.json"
ENV NOIRCON_CACHE="/app/cache"
RUN /usr/local/bin/noircon --init -c "$NOIRCON_CONFIG" -C "$NOIRCON_CACHE"

# Set the CMD to run the startup script and keep the container running
CMD ["/bin/sh", "-c", "/usr/local/bin/noircon -c '/app/noircon.json' --start && tail -f /dev/null"]