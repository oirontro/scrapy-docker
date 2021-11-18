# scrapy in docker container #

1. apt and pip install from mirrors in China,
2. local Python package installed in develop mode if mounted under
   `/dev_packages`,
3. non-root user supported,
4. default user `dev` with `1000:1000`, and
5. new user `user` could be created on the fly if `-e LOCAL_USER_ID=$(id -u)`.

Usages:

    docker run -it --rm -e LOCAL_USER_ID=$(id -u) --network=scrapy -e DATABASE_URL -v $(pwd):/app -v $ROOT_PATH/my_awesome_package:/dev_packages/my_awesome_package caky/scrapy bash


Based on:

1. <https://github.com/aciobanu/docker-scrapy>
2. <https://gist.github.com/yogeek/bc8dc6dadbb72cb39efadf83920077d3>
