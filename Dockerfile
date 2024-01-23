# Use the official Superset image
FROM apache/superset

# Install dependencies for PyMongo
USER root
RUN pip install pymongo

# Copy the entry-point script and set permissions
COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

# Swtich back to superset user
USER superset

# Set the entry-point script
ENTRYPOINT ["/entry-point.sh"]
