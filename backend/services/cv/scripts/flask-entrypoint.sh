#!/bin/bash

# Start server
echo "Starting server"
gunicorn --log-level DEBUG --bind 0.0.0.0:8000 main:app