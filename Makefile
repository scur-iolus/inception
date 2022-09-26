# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: llalba <llalba@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/09/14 11:02:31 by llalba            #+#    #+#              #
#    Updated: 2022/09/26 15:51:36 by llalba           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

green			= /bin/echo -e "\x1b[1m\x1b[32m$1\x1b[0m"
,				:= ,

DOCKER_COMPOSE	= docker-compose
COMPOSE_FILE	= ./srcs/docker-compose-copy.yml

all:			up # the 1st target is the default target: here 'up' isn't a command, it's a prerequisite

up:				# Starts all or c=<name> containers in foreground
				@$(call green,"🚀 Builds$(,) creates and starts containers")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up --build $(c)

start:			# Starts all or c=<name> containers in background
				@$(call green,"🚀 Builds$(,) creates and starts containers in detached mode")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up --build -d $(c)

stop:			# Stops all or c=<name> containers
				@$(call green,"⏸ Stops running containers without removing them")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) stop $(c)

restart:		# Restarts all or c=<name> containers
				@$(call green,"🚀 Restarts containers")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) stop $(c)
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up $(c) -d

logs:			# Shows logs for all or c=<name> containers
				@$(call green,"📃 Displays log output from services")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs --tail=100 -f $(c)

status:			# Shows status of containers
				@$(call green,"📸 Lists containers for a Compose project with current status")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) ps

ps:				status # Alias of status

volumes:		# Lists volumes
				@$(call green,"📸 Lists all the volumes known to Docker")
				docker volume ls

clean:			# Cleans COMPOSE_FILE related data
				@$(call green,"🧹 Stops and removes containers$(,) networks$(,) volumes and images")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

fclean:			# Cleans all data, including all images used by any service, volumes, containers
				@$(call green,"🧹 Stops and removes any containers$(,) networks$(,) volumes and images")
				$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down --rmi all --volumes --remove-orphans

# runs the recipes regardless of whethere there are files with those names
# those commands do not represent physical files and are always out-of-date targets
.PHONY: all up start stop restart status ps volumes clean fclean
