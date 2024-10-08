# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fschnorr <fschnorr@student.42berlin.de>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/09 15:38:23 by fschnorr          #+#    #+#              #
#    Updated: 2024/10/08 12:44:16 by fschnorr         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = libftprintf.a
SRC = src/ft_printf.c
OBJS := $(SRC:%.c=%.o)
CFLAGS := -Wall -Werror -Wextra
INCLUDES = -I includes
LIBFT_INCLUDES = -I lib/libft/includes
LIBFT_DIR = lib/libft
LIBFT_SRC_DIRS = $(LIBFT_DIR)/src/ctype $(LIBFT_DIR)/src/memory $(LIBFT_DIR)/src/stdio $(LIBFT_DIR)/src/string $(LIBFT_DIR)/src/stdlib $(LIBFT_DIR)/src/utils
LIBFT_SRC = $(foreach dir, $(LIBFT_SRC_DIRS), $(wildcard $(dir)/*.c))

all: $(NAME)

$(NAME): $(OBJS)
	@make -C $(LIBFT_DIR)
	@cp $(LIBFT_DIR)/libft.a .
	@mv libft.a $(NAME)
	@ar rcs $(NAME) $(OBJS)
	@echo "ran ar."

%.o: %.c
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) -c $< -o $@
	@echo "ran cc."

clean:
	@rm -f $(OBJS)
	@echo "ran clean."

fclean: clean
	@rm -f $(NAME)
	@rm -f ft_printf.out
	@make fclean -C $(LIBFT_DIR)
	@echo "ran fclean."

re: fclean all

run:
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) $(SRC) $(LIBFT_SRC) -o ft_printf.out
	@./ft_printf.out

valgrind: 
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) $(SRC) $(LIBFT_SRC) -g -O0 -o ft_printf.out
	@valgrind --leak-check=full ./ft_printf.out