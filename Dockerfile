# Use the official Superset image
FROM apache/superset

# Install dependencies for PyMongo
USER root

# Update apt-get and install wget
RUN apt-get update && \
    apt-get install -y wget

# Download the PEM file
RUN wget -O /usr/local/share/ca-certificates/aws-cert.pem "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem"

# Update CA certificates
RUN chmod 644 /usr/local/share/ca-certificates/aws-cert.pem && \
    update-ca-certificates

# Copy the entry-point script and set permissions
COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

# Swtich back to superset user
USER superset

# Install pymongo driver
RUN pip install --requirement requirements.txt

# Set the entry-point script
ENTRYPOINT ["/entry-point.sh"]