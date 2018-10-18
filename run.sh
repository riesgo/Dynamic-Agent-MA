#!/bin/bash

if [ ! -f ma.env ]
then

  echo "You must include an ma.env file"

else

  export $(cat ma.env | xargs)

  if [[ "x$CONTROLLER_HOST" == "x" || "x$CONTROLLER_PORT" == "x" || "x$CONTROLLER_SSL_ENABLED" == "x" || "x$APPLICATION_NAME" == "x" || "x$ACCOUNT_ACCESS_KEY" == "x" ]]; then

    echo "CONTROLLER_HOST, CONTROLLER_PORT, CONTROLLER_SSL_ENABLED, APPLICATION_NAME, ACCOUNT_NAME, and ACCOUNT_ACCESS_KEY are required"

  else

    if [[ "x$FULL_ACCOUNT_NAME" != "x" && "x$EVENT_ENDPOINT" != "x" && "x$NETWORK_NAME" != "x" ]]; then

      # Enable analytics
      docker run -d -e "CONTROLLER_HOST=$CONTROLLER_HOST" -e "CONTROLLER_PORT=$CONTROLLER_PORT" -e "CONTROLLER_SSL_ENABLED=$CONTROLLER_SSL_ENABLED" \
		-e "APPLICATION_NAME=$APPLICATION_NAME" -e "ACCOUNT_NAME=$ACCOUNT_NAME" -e "ACCOUNT_ACCESS_KEY=$ACCOUNT_ACCESS_KEY" \
		-e "EVENT_ENDPOINT=$EVENT_ENDPOINT" -e "FULL_ACCOUNT_NAME=$FULL_ACCOUNT_NAME" --network=$NETWORK_NAME \
		-e "TIER_NAME_FROM=$TIER_NAME_FROM" -e "TIER_NAME_PARAM=$TIER_NAME_PARAM" -e "ENABLE_ANALYTICS=1" \
		--expose "9090" --hostname machine-agent --volume "/var/run/docker.sock:/var/run/docker.sock" --name machine-agent machine-agent

    else

      # Disable analytics
      docker run -d -e "CONTROLLER_HOST=$CONTROLLER_HOST" -e "CONTROLLER_PORT=$CONTROLLER_PORT" -e "CONTROLLER_SSL_ENABLED=$CONTROLLER_SSL_ENABLED" \
  		-e "APPLICATION_NAME=$APPLICATION_NAME" -e "ACCOUNT_NAME=$ACCOUNT_NAME" -e "ACCOUNT_ACCESS_KEY=$ACCOUNT_ACCESS_KEY" \
		-e "TIER_NAME_FROM=$TIER_NAME_FROM" -e "TIER_NAME_PARAM=$TIER_NAME_PARAM" -e "ENABLE_ANALYTICS=0" \
  		--expose "9090" --hostname machine-agent --volume "/var/run/docker.sock:/var/run/docker.sock" --name machine-agent machine-agent

    fi

  fi
	
fi
