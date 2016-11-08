## Usage


### To build use:
###   docker build -t k-d-w2p .
### To run:
###   docker run --name K_SG -p 80:80 -p 443:443 -d k-d-w2p
### Using existing application on docker host
###   docker run -p 80:80 -p 443:443 -v /local/path/to/myapp:/home/www-data/web2py/applications/myapp -d k-d-w2p
### example for start container named K_SG using application SG at same folder as dockerfile: 
###   docker run --name K_SG  -p 80:80 -p 443:443 -v ./SG:/home/www-data/web2py/applications/SG -d k-d-w2p
###   docker exec -i -t K_SG chmod -R 775 /home/www-data/web2py/applications/SG
###   docker exec -i -t K_SG chown -R www-data:www-data /home/www-data/web2py/applications/SG
###   docker exec -i -t K_SG /bin/bash



Running a new instance of web2py:

```
docker run -p 8000:8000 -p 443:443 -d rafs/web2py
Running an instance of web2py to include an existing web2py application:
```
---
```
docker run -p 8000:8000 -p 443:443 -v /local/path/to/myapp:/home/www-data/web2py/applications/myapp -d rafs/web2py
```
---
Example Dockerfile to build web2py application into Docker container:
```
FROM rafs/web2py
COPY /local/path/to/myapp /home/www-data/web2py/applications/myapp
RUN chown -R www-data:www-data /home/www-data/web2py/applications/myapp && \
    ln -s /home/www-data/web2py/applications/myapp /home/www-data/web2py/applications/init
```

---

Inspired by: [thehipbot](https://hub.docker.com/r/thehipbot/web2py/)
