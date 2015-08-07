FROM ubuntu:14.04
RUN apt-get update 
RUN apt-get -y upgrade
RUN apt-get install -y  apache2 apache2-dev
RUN apt-get upgrade openssl
RUN apt-get install -y libapache2-mod-php5 
# Install base packages
RUN apt-get install -y  \
    libxml2-dev \
    libcurl4-openssl-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    libmysqlclient-dev \
    libpq-dev \
    libicu-dev \
    libfreetype6-dev \
    libldap2-dev \
    libxslt-dev
ENV PHP_VERSION 5.6.11
RUN apt-get install build-essential
RUN apt-get install -y wget
RUN wget "http://in1.php.net/get/php-5.6.11.tar.bz2/from/this/mirror" -O /root/php-5.6.11.tar.bz2
WORKDIR /root
RUN pwd
RUN bunzip2 php-5.6.11.tar.bz2
RUN tar -xf php-5.6.11.tar
WORKDIR php-5.6.11
RUN ./configure \
  --prefix=/usr/local/php \
  --with-apxs2=/usr/bin/apxs \
  --enable-mbstring \
  --with-curl \
  --with-openssl \
  --with-xmlrpc \
  --enable-soap \
  --enable-zip \
  --with-gd \
  --with-jpeg-dir \
  --with-png-dir \
  --with-mysql \
  --with-pgsql \
  --enable-embedded-mysqli \
  --with-freetype-dir \
  --enable-intl \
  --with-xsl
RUN make 
RUN make install
RUN cp php.ini-production /usr/local/lib/php.ini
RUN ln -s /usr/local/lib/php.ini /etc
RUN echo "LoadModule php5_module  modules/libphp5.so" >> /etc/apache2/apache2.conf
RUN echo "AddType application/x-http-php .php" >> /etc/apache2/apache2.conf 
RUN /etc/init.d/apache2 restart
WORKDIR /var/www/html
EXPOSE 80
 
