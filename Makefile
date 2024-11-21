# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fschnorr <fschnorr@student.42berlin.de>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/09 15:38:23 by fschnorr          #+#    #+#              #
#    Updated: 2024/11/21 12:02:44 by fschnorr         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = libftprintf.a
INCLUDES = -I includes
SRC = src/ft_printf.c
OBJS := $(SRC:%.c=%.o)

CFLAGS := -Wall -Werror -Wextra
MFLAGS = --no-print-directory

LIBFT_INCLUDES = -I lib/libft/includes
LIBFT_DIR = lib/libft
LIBFT_AR = $(LIBFT_DIR)/libft.a

all: $(NAME)

$(NAME): $(OBJS)
	@make -C $(LIBFT_DIR) $(MFLAGS)
	@cp $(LIBFT_AR) .
	@mv libft.a $(NAME)
	@ar rcs $(NAME) $(OBJS)
	@echo "ran ar for printf"

%.o: %.c
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) -c $< -o $@
	
clean:
	@rm -f $(OBJS)
	
fclean: clean
	@rm -f $(NAME)
	@rm -f ft_printf.out
	@make fclean -C $(LIBFT_DIR) $(MFLAGS)
	@echo "ran fclean for printf"

re: fclean all

run:
	@make -C $(LIBFT_DIR) $(MFLAGS)
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) $(SRC) $(LIBFT_AR) -o ft_printf.out
	@./ft_printf.out

valgrind: 
	@make -C $(LIBFT_DIR) $(MFLAGS)
	@cc $(CFLAGS) $(INCLUDES) $(LIBFT_INCLUDES) $(SRC) $(LIBFT_AR) -g -O0 -o ft_printf.out
	@valgrind --leak-check=full ./ft_printf.out