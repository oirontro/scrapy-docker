# scrapy in docker container #

1. apt and pip install from mirrors in China,
2. Python packages installed by user `root`, if `requirements.txt` under default
   working directory,
3. local Python packages installed in develop mode by user `root`, if mounted
   under `/dev_packages`,
4. non-root user supported,
   + non-root user `dev` would have the same `uid:gid` as the directory mounted
     to `/app`, if environment variable `LOCAL_USER_ID` not specified,
     otherwise,
   + new user `user` would be created according to environment variable
     `LOCAL_USER_ID`, for example, if `docker run` with `-e LOCAL_USER_ID=$(id
     -u)`.
   + `sudo` without password
5. directory `/data` owned by current user.

Usages:

    docker run -it --rm --network=scrapy -e DATABASE_URL -v $(pwd):/app -v $ROOT_PATH/my_awesome_package:/dev_packages/my_awesome_package caky/scrapy bash


Based on:

1. <https://github.com/aciobanu/docker-scrapy>
2. <https://gist.github.com/yogeek/bc8dc6dadbb72cb39efadf83920077d3>
