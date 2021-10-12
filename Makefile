# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tkomatsu <tkomatsu@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/08 20:22:12 by tkomatsu          #+#    #+#              #
#    Updated: 2021/10/12 11:17:53 by tkomatsu         ###   ########.fr        #
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
SRC_DIR = srcs/
OBJ_DIR = objs/
LIB_DIR = lib/
VPATH = $(SRC_DIR):$(SRC_DIR)utils

# Config
# ****************************************************************************

SHELL = /bin/bash
CC = gcc
CXX = clang++
INCLUDE = includes
CXX_INCLUDE = -I $(shell echo $(VPATH) | sed 's/:/ -I /g')

BASEFLAGS = -Wall -Werror -Wextra -MMD -MP
CFLAGS = $(BASEFLAGS) -I $(INCLUDE)
CXXFLAGS = $(BASEFLAGS) -std=c++98 $(CXX_INCLUDE)
LIBFLAGS = -L $(LIB_DIR)$(LIBFT) -lft
DEBUG_FLAGS = -g3

# Source files
# ****************************************************************************

# C program
SRCS = $(shell find $(SRC_DIR) -name '*.c' | sed 's!^.*/!!')
OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.c=.o))

# C++ program
# SRCS = $(shell find $(SRC_DIR) -name '*.cpp' | sed 's!^.*/!!')
# OBJS = $(addprefix $(OBJ_DIR), $(SRCS:.cpp=.o))

DEPENDS = $(OBJS:.o=.d)

# Recipe
# ****************************************************************************

all: $(LIBFT) $(NAME)

# C program
$(NAME): $(LIB_DIR)$(LIBFT)/$(LIBFT).a $(OBJS)
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

$(OBJ_DIR)%.o: %.c
	@if [ ! -d $(OBJ_DIR) ];then mkdir $(OBJ_DIR); fi
	@$(CC) $(CFLAGS) -c $< -o $@ 
	@printf "$(_GREEN)█$(_END)"

$(OBJ_DIR)%.o: %.cpp
	@if [ ! -d $(OBJ_DIR) ];then mkdir $(OBJ_DIR); fi
	@$(CXX) $(CXXFLAGS) -c $< -o $@ 
	@printf "$(_GREEN)█$(_END)"

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
debug: CXXFLAGS += -fsanitize=address $(DEBUG_FLAGS)
debug: re
	@printf "$(_BLUE)Debug build done$(_END)\n"

leak: CFLAGS += $(DEBUG_FLAGS)
leak: CXXFLAGS += $(DEBUG_FLAGS)
leak: re
	@printf "$(_BLUE)Leak check build done$(_END)\n"

check: all
	./$(NAME)

-include $(DEPENDS)

PHONY: all clean fclean re debug leak test libft

