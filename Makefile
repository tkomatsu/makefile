# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tkomatsu <tkomatsu@student.42tokyo.jp>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/01/08 20:22:12 by tkomatsu          #+#    #+#              #
#    Updated: 2021/03/02 21:00:01 by tkomatsu         ###   ########.fr        #
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

CC = gcc

INCLUDE = includes

CFLAGS = -Wall -Werror -Wextra -I $(INCLUDE)
LIBFLAGS = -L $(LIB_DIR)libft -lft

DEBUG_CFLAGS = -g3

# Source files
# ****************************************************************************
#
# utility

UTIL_DIR = utils/
UTIL_FILES = utils.c

UTIL_SRCS = $(addprefix $(UTIL_DIR), $(UTIL_FILES))

SRC_FILES =	main.c \
			$(UTIL_SRCS)

# addprefix

SRC_DIR = srcs/
LIB_DIR = lib/

OBJ_DIR = objs/
OBJS = $(SRC_FILES:%.c=$(OBJ_DIR)%.o)

# Recipe
# ****************************************************************************

all: $(NAME)

$(NAME): $(LIBFT) $(OBJS)
	@echo "$(_END)\nCompiled source files"
	@$(CC) $(CFLAGS) $(OBJS) $(LIBFLAGS) -o $@
	@echo "$(_GREEN)Finish compiling $(NAME)!"
	@echo "Try \"./$(NAME)\" to use$(_END)"

$(LIBFT):
	@make -C $(LIB_DIR)$(LIBFT)

$(OBJS): $(OBJ_DIR)

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	@$(CC) $(CFLAGS) -c $< -o $@ 
	@printf "$(_GREEN)█"

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)$(UTIL_DIR)

clean:
	@echo "$(_YELLOW)Removing object files ...$(_END)"
	@make clean -C $(LIB_DIR)$(LIBFT)
	@rm -rf $(OBJ_DIR)
	@rm -fr *.dSYM

fclean:
	@echo "$(_RED)Removing object files and program ...$(_END)"
	@make fclean -C $(LIB_DIR)$(LIBFT)
	@rm -rf $(NAME) $(OBJ_DIR)
	@rm -fr *.dSYM

re: fclean all

debug: CFLAGS += -fsanitize=address $(DEBUG_CFLAGS)
debug: re
	@echo "$(_BLUE)Debug build done$(_END)"

leak: CFLAGS += $(DEBUG_CFLAGS)
leak: re
	@echo "$(_BLUE)Leak check build done$(_END)"

test: all
	@cd test && bash check.sh

PHONY: all clean fclean re debug leak test libft

