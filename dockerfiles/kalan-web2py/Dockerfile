# Version: 0.0.1

FROM centos

# env vars
ENV PW admin
ENV INSTALL_DIR /home/www-data
ENV W2P_DIR $INSTALL_DIR/web2py
ENV CERT_PASS web2py

# update ubuntu and install necessary packages

RUN yum -y update && \
	yum -y install python-dev libxml2-dev python-pip unzip wget supervisor && \
	yum -y install deltarpm python-deltarpm yum-utils unzip nano net-tools wget git ntp dialog dvd+rw-tools createrepo sudo && \
	yum -y install gcc make zlib-devel bzip2-devel  ncurses-devel libxml2-devel libxml2 libxml2-python libxslt-devel  pcre-devel curl-devel python-devel && \
	yum -y install policycoreutils-python nmap openscap openscap-scanner scap-security-guide openssl openssl-devel && \
	yum -y install sqlite sqlite-devel mysql-devel unixODBC-devel postgresql-devel && \
	yum -y install postgresql postgresql-server postgresql-contrib postgresql-libs postgresql-plperl postgresql-plpython python-psycopg && \
	yum -y install graphviz graphviz-devel ImageMagick supervisor && \
	yum -y install xz-libs && \
	yum -y install vim-enhanced* && \
	yum -y install genisoimage  libusal pykickstart && \
	yum -y install chrony && \
	yum -y install epel-release && \
	yum -y --enablerepo=epel install nginx && \
	mkdir -p /opt/kalan/sw/ && \
	cd /opt/kalan/sw/

RUN wget -qO- https://raw.githubusercontent.com/dlintec/kalan/master/kalan-setup.sh | bash -i

RUN kalan-install-python.sh && \
   pip2.7 install --upgrade uwsgi && \
	mkdir /etc/nginx/conf.d/web2py

#	pip2.7 install setuptools --no-use-wheel --upgrade && \
#	PIPPATH=`which pip` && \
#	$PIPPATH install --upgrade uwsgi && \


# copy nginx config files from repo
COPY gzip_static.conf /etc/nginx/conf.d/web2py/gzip_static.conf
COPY gzip.conf /etc/nginx/conf.d/web2py/gzip.conf
COPY web2py /etc/nginx/sites-available/web2py

# setup nginx
#RUN ln -sf /etc/nginx/sites-available/web2py /etc/nginx/sites-enabled/web2py && \
#RUN rm /etc/nginx/sites-enabled/default && \
RUN	mkdir /etc/nginx/ssl && cd /etc/nginx/ssl && \
	openssl genrsa -passout pass:$CERT_PASS 1024 > web2py.key && \
	chmod 400 web2py.key && \
	openssl req -new -x509 -nodes -sha1 -days 1780 -subj "/C=US/ST=Denial/L=Chicago/O=Dis/CN=www.example.com" -key web2py.key > web2py.crt && \
	openssl x509 -noout -fingerprint -text < web2py.crt > web2py.info && \
	mkdir /etc/uwsgi && \
	mkdir /var/log/uwsgi

# copy Emperor config files from repo
COPY web2py.ini /etc/uwsgi/web2py.ini
COPY uwsgi-emperor.conf /etc/init/uwsgi-emperor.conf

# copy Supervisor config file from repo
COPY supervisor-app.conf /etc/supervisor/conf.d/



# get and install web2py
RUN useradd -s /usr/sbin/nologin -r -M -d /dev/null kalan
RUN mkdir $INSTALL_DIR && cd $INSTALL_DIR && \
	wget http://web2py.com/examples/static/web2py_src.zip && \
	unzip web2py_src.zip && \
	rm web2py_src.zip && \
	mv web2py/handlers/wsgihandler.py web2py/wsgihandler.py && \
	chown -R kalan:kalan web2py && \
	cd $W2P_DIR && \
	python2.7 -c "from gluon.main import save_password; save_password('$PW',80)" && \
	python2.7 -c "from gluon.main import save_password; save_password('$PW',443)" && \
	nginx



EXPOSE 80 443 8000

WORKDIR $W2P_DIR

CMD ["supervisord", "-n"]
