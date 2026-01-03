#!/bin/bash

# ===== CONFIG =====
STAGING_DIR="/var/www/staging"
PRODUCTION_DIR="/var/www/production"
LOG_FILE="/var/log/deploy.log"

# ===== GET CURRENT BRANCH =====
BRANCH=$(git branch --show-current)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Starting deployment from branch: $BRANCH" >> $LOG_FILE

# ===== DEPLOY LOGIC =====
if [ "$BRANCH" = "staging" ]; then
    echo "Deploying to STAGING environment..."
    rsync -av --delete ./ $STAGING_DIR --exclude=.git
    echo "[$TIMESTAMP] Staging deployment successful" >> $LOG_FILE

elif [ "$BRANCH" = "production" ]; then
    echo "Deploying to PRODUCTION environment..."
    rsync -av --delete ./ $PRODUCTION_DIR --exclude=.git
    echo "[$TIMESTAMP] Production deployment successful" >> $LOG_FILE

else
    echo "❌ ERROR: Not on a deployable branch"
    echo "[$TIMESTAMP] Deployment failed: invalid branch ($BRANCH)" >> $LOG_FILE
    exit 1
fi

echo "✅ Deployment completed successfully"

