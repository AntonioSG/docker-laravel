FROM php:8.3.0-apache-bullseye
COPY --chown=www-data:www-data ./gestion-imagen-personal-backend /var/www/html/


RUN apt-get update 
RUN apt-get install -y zip libzip-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 

RUN cp $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/conf.d/php.ini

RUN sed -i 's/;extension=zip/extension=zip/g' $PHP_INI_DIR/conf.d/php.ini
RUN sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/g' $PHP_INI_DIR/conf.d/php.ini
RUN sed -i 's#DocumentRoot /var/www/html#DocumentRoot /var/www/html/public#g' /etc/apache2/sites-available/000-default.conf
#RUN sed -ri -e 's/^([ \t]*)(<\/VirtualHost>)/\1\tHeader set Access-Control-Allow-Origin "*"\n\1\2/g' /etc/apache2/sites-available/000-default.conf



RUN docker-php-ext-install pdo pdo_mysql zip





WORKDIR /var/www/html
#RUN chown -R www-data:www-data *
RUN composer install



#RUN a2enmod headers
RUN a2enmod rewrite

