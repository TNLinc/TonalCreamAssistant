#!/bin/bash

# Start server
echo "Starting server"
uvicorn main:app --host 0.0.0.0 --port 8000