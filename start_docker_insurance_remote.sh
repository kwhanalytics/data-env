#!/bin/bash
docker rm ins_develop
MYPORT=$(grep "c.NotebookApp.port" ~/.jupyter/jupyter_notebook_config.py | tail -c 5)

if [ "$1" == "--start-jupyter" ]; then
    docker-compose -f remote-docker-compose.yml run -d -p $MYPORT:8888 \
	-v $SSH_AUTH_SOCK:/ssh-agent \
	-e SSH_AUTH_SOCK=/ssh-agent \
	--name ins_develop insurance_env && \
        docker exec ins_develop jupyter notebook --ip 0.0.0.0 --port $MYPORT --no-browser --allow-root --NotebookApp.token='kwh'
elif ["$1" == ""]; then
    docker-compose -f remote-docker-compose.yml run -d -p $MYPORT:8888 \
	-v $SSH_AUTH_SOCK:/ssh-agent \
	-e SSH_AUTH_SOCK=/ssh-agent \
	--name ins_develop insurance_env bash && \
	docker exec -it ins_develop bash
else
    echo "Invalid arg. Please indicate --start-jupyter if you want to start Jupyter."\
        "Don't add an argument if you want to exec into bash on docker startup."
fi

