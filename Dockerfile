FROM        ubuntu
MAINTAINER  Nicholas Johns "nicholas.a.johns5@gmail.com"

# Force update 
# install wget, curl, and python-software-properties for adding PPA's
# curl and python-software-properties are not necessary but I like them.
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update; apt-get upgrade -y; apt-get install -y wget curl python-software-properties

# Let's install php 5.5

#Add PPA
RUN add-apt-repository ppa:ondrej/php5

# Install PHP 5.5
# As well as curl, mcrypt, and mysqlnd.
RUN apt-get update; apt-get install -y php5-cli php5 php5-mcrypt php5-curl php5-mysqlnd
 
# Let's set the default timezone in both cli and apache configs
# I live in Japan so let's set it to Asia/Tokyo
# Thanks jtreminio.
RUN perl -pi -e "s#;date.timezone =#date.timezone = Asia/Tokyo#g" /etc/php5/cli/php.ini
RUN perl -pi -e "s#;date.timezone =#date.timezone = Asia/Tokyo#g" /etc/php5/apache/php.ini

# Stop apache, we're only only using this as a base so we will start apache in another image
RUN service apache2 stop

# Source our envvars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

# Expose port 80
EXPOSE 80

# At this point we will stop here, commit and use it as a base
