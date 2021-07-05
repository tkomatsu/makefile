# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tkomatsu <tkomatsu@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/08 20:22:12 by tkomatsu          #+#    #+#              #
#    Updated: 2021/05/06 15:47:54 by tkomatsu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors
# ****************************************************************************

_GREY	= \033[30m
_RED	= \033[31m
_GREEN	= \033[32m
_YELLOW	= \033[33m
_BLUE	= \033[34m
_PURPLE	= \033[35m
_CYAN	= \033[36m
_WHITE	= \033[37m
_END	= \033[0m

# ****************************************************************************

NAME = template
LIBFT = libft

# Config
# ****************************************************************************

SHELL = /bin/bash
CC = gcc
CXX = clang++
INCLUDE = includes
CFLAGS = -Wall -Werror -Wextra -I $(INCLUDE)
CXXFLAGS = -Wall -Werror -Wextra -std=c++98 -I $(INCLUDE)
LIBFLAGS = -L $(LIB_DIR)libft -lft
DEBUG_FLAGS = -g3

# Source files
# ****************************************************************************

SRC_DIR = srcs/
OBJ_DIR = objs/
LIB_DIR = lib/

# C program
SRCS = $(shell find $(SRC_DIR) -name '*.c' | sed 's!^.*/!!')
OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.c=.o))

# C++ program
# SRCS = $(shell find $(SRC_DIR) -name '*.cpp' | sed 's!^.*/!!')
# OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.cpp=.o))

# Recipe
# ****************************************************************************

all: $(NAME)

# C program
$(NAME): $(LIBFT) $(OBJS)
	@printf "$(_END)\nCompiled source files\n"
	@$(CC) $(CFLAGS) $(OBJS) $(LIBFLAGS) -o $@
	@printf "$(_GREEN)Finish compiling $(NAME)!\n"
	@printf "Try \"./$(NAME)\" to use$(_END)\n"

$(LIBFT):
	@make -C $(LIB_DIR)$(LIBFT)

# C++ program
# $(NAME): $(OBJS)
# 	@printf "$(_END)\nCompiled source files\n"
# 	@$(CXX) $(CXXFLAGS) $(OBJS) -o $@
# 	@printf "$(_GREEN)Finish compiling $@!\n"
# 	@printf "Try \"./$@\" to use$(_END)\n"

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@if [ ! -d $(OBJ_DIR) ];then mkdir $(OBJ_DIR); fi
	@$(CC) $(CFLAGS) -c $< -o $@ 
	@printf "$(_GREEN)█"

$(OBJ_DIR)%.o: $(SRC_DIR)%.cpp
	@if [ ! -d $(OBJ_DIR) ];then mkdir $(OBJ_DIR); fi
	@$(CXX) $(CXXFLAGS) -c $< -o $@ 
	@printf "$(_GREEN)█"

clean:
	@printf "$(_YELLOW)Removing object files ...$(_END)\n"
	@make clean -C $(LIB_DIR)$(LIBFT)
	@rm -rf $(OBJ_DIR)
	@rm -fr *.dSYM

fclean:
	@printf "$(_RED)Removing object files and program ...$(_END)\n"
	@make fclean -C $(LIB_DIR)$(LIBFT)
	@rm -rf $(NAME) $(OBJ_DIR)
	@rm -fr *.dSYM

re: fclean all

debug: CFLAGS += -fsanitize=address $(DEBUG_FLAGS)
debug: re
	@printf "$(_BLUE)Debug build done$(_END)\n"

leak: CFLAGS += $(DEBUG_FLAGS)
leak: re
	@printf "$(_BLUE)Leak check build done$(_END)\n"

check: re
	./$(NAME)

PHONY: all clean fclean re debug leak test libft

