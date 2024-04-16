# Use an official PHP image as a base image
FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip sockets 

# Install Composer globally and allow superuser
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Set COMPOSER_ALLOW_SUPERUSER to 1
ENV COMPOSER_ALLOW_SUPERUSER 1

# Set the working directory
WORKDIR /var/www

RUN composer global require laravel/installer

RUN composer create-project --prefer-dist laravel/laravel:^7.4 html

WORKDIR /var/www/html

# Copy Laravel application files into the container
COPY ./laravel-app /var/www/html

RUN chmod -R 777 /var/www/html/

# # Install Laravel application dependencies
RUN composer install

# # Start PHP-FPM
# CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

# # Expose port 9000 for PHP-FPM
# EXPOSE 8000
