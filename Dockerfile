FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y webhook sox libsox-fmt-all

# Set the working directory
WORKDIR /etc/webhook

# Expose the webhook port
EXPOSE 9000

# Start the webhook server
CMD ["webhook", "-hooks", "hooks.json", "-verbose"]
