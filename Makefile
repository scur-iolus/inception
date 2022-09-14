# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: llalba <llalba@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/09/14 11:02:31 by llalba            #+#    #+#              #
#    Updated: 2022/09/14 11:07:05 by llalba           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


NAME			= executable

SRC_DIR			= src

OBJ_DIR			= obj

INC_DIR			= include

SRC				= main.cpp

OBJ				= $(SRC:%.cpp=$(OBJ_DIR)/%.o)

DEPS			= $(SRC:%.cpp=$(OBJ_DIR)/%.d)

CXXFLAGS		= -Wall -Wextra -Werror -std=c++98

all:			$(NAME)

$(NAME):		$(OBJ)
				c++ $(CXXFLAGS) $^ -o $@

$(OBJ_DIR):
				mkdir $@

-include $(DEPS)

$(OBJ_DIR)/%.o:	$(SRC_DIR)/%.cpp | $(OBJ_DIR)
				c++ $(CXXFLAGS) -MMD -MP $(INC_DIR:%=-I %) -c $< -o $@

clean:
				rm -rf $(OBJ_DIR)


fclean:			clean
				rm -f $(NAME)

re:				fclean all

.PHONY: all clean fclean re
