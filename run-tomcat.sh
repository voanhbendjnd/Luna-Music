#!/bin/bash
echo "Building Luna Music project..."
mvn clean package

echo "Starting Tomcat server..."
mvn tomcat7:run
