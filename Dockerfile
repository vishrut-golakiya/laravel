FROM ubuntu:22.04

RUN apt-get update -y

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install apache2 -y

RUN apt-get -y install software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install php8.4

RUN apt-get install -y php8.4 php8.4-cli php8.4-fpm php8.4-common php8.4-bcmath php8.4-bz2 php8.4-curl php8.4-gd php8.4-intl php8.4-mbstring php8.4-mysql php8.4-opcache php8.4-pgsql php8.4-soap php8.4-xml php8.4-zip


RUN apt-get update && apt-get -y install php-cli unzip && \
    cd ~ && apt-get -y install curl && \
    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
    HASH=`curl -sS https://composer.github.io/installer.sig` && \
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

COPY ./000-default.conf  /etc/apache2/sites-available 

COPY ./myApp /var/www/html/myApp

WORKDIR /var/www/html/myApp

RUN composer update --no-interaction --prefer-dist

RUN chown -R www-data:www-data /var/www/html/myApp

RUN chmod -R 775 /var/www/html/myApp/storage

RUN chown -R www-data:www-data /var/www/html/myApp/storage

RUN php artisan key:generate 

RUN php artisan migrate --force

EXPOSE 80 3306

CMD ["apachectl", "-D", "FOREGROUND"]

# DB_CONNECTION=mysql
# DB_HOST=${{ secrets.DB_HOST }}
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=${{ secrets.DB_USERNAME }}
# DB_PASSWORD=${{ secrets.DB_PASSWORD }}
