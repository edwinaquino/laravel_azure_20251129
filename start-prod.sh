#!/bin/sh

echo "Starting Laravel production container..."

# Wait for .env file to be available
if [ -f /var/www/html/.env ]; then
    echo ".env file found"
    
    # Run Laravel optimization commands
    echo "Running Laravel optimizations..."
    php artisan config:cache || echo "Config cache failed (non-fatal)"
    php artisan route:cache || echo "Route cache failed (non-fatal)"
    php artisan view:cache || echo "View cache failed (non-fatal)"
else
    echo "Warning: .env file not found, skipping optimizations"
fi

# Ensure proper permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Start PHP-FPM in the background
echo "Starting PHP-FPM..."
php-fpm &

# Give PHP-FPM a moment to start
sleep 2

# Start Nginx in the foreground
echo "Starting Nginx on port 80..."
nginx -g 'daemon off;'