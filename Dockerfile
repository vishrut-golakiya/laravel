FROM ubuntu:22.04

RUN apt-get update -y

#Installing apache in non-interactive mode
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install apache2 -y

#Installing PHP v 8.2
RUN apt-get -y install software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install php8.3

RUN apt-get install -y php8.3-bcmath php8.3-fpm php8.3-xml php8.3-mysql php8.3-zip php8.3-intl php8.3-ldap php8.3-gd php8.3-cli php8.3-bz2 php8.3-curl php8.3-mbstring php8.3-pgsql php8.3-opcache php8.3-soap php8.3-cgi

RUN apt-get update && apt-get -y install php-cli unzip && \
    cd ~ && apt-get -y install curl && \
    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && \
    HASH=`curl -sS https://composer.github.io/installer.sig` && \
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer


COPY ./000-default.conf  /etc/apache2/sites-available 

COPY ./myApp /var/www/html/myApp

WORKDIR /var/www/html/myApp

# COPY .env.example .env

RUN chown -R www-data:www-data /var/www/html/myApp

RUN chmod -R 775 /var/www/html/myApp/storage

RUN chown -R www-data:www-data /var/www/html/myApp/storage

RUN composer install

# RUN php artisan key:generate 

# RUN php artisan migrate --force

EXPOSE 80 3306

# CMD ["sh", "-c", "service mysql start && apachectl -D FOREGROUND"]
CMD ["apachectl", "-D", "FOREGROUND"]









# DB_CONNECTION=mysql
# DB_HOST=${{ secrets.DB_HOST }}
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=${{ secrets.DB_USERNAME }}
# DB_PASSWORD=${{ secrets.DB_PASSWORD }}














