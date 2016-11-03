## Usage
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
