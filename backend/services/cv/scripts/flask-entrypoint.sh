#!/bin/bash

# Start server
echo "Starting server"
gunicorn --access-logfile - --log-file - --log-level DEBUG --bind 0.0.0.0:8000 main:app