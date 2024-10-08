/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: fschnorr <fschnorr@student.42berlin.de>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/08/29 10:00:24 by fschnorr          #+#    #+#             */
/*   Updated: 2024/10/08 12:47:15 by fschnorr         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"
#include "libft.h"
#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>

static int	ft_puthex_fd(unsigned int nbr, int fd, const char format)
{
	int		output_ct;

	output_ct = 0;
	if (nbr >= 16)
	{
		output_ct += ft_puthex_fd(nbr / 16, fd, format);
		output_ct += ft_puthex_fd(nbr % 16, fd, format);
	}
	else
	{
		if (nbr > 9)
		{
			if (format == 'x')
				output_ct += ft_putchar_fd((nbr - 10 + 'a'), fd);
			if (format == 'X')
				output_ct += ft_putchar_fd((nbr - 10 + 'A'), fd);
		}
		else
			output_ct += ft_putchar_fd((nbr + '0'), fd);
	}
	return (output_ct);
}

static int	ft_putunsigned_fd(unsigned int nbr, int fd)
{
	int		output_ct;
	char	c;

	output_ct = 0;
	if (nbr > 9)
	{
		output_ct += ft_putunsigned_fd(nbr / 10, fd);
		output_ct += ft_putunsigned_fd(nbr % 10, fd);
	}
	else
	{
		c = nbr + 48;
		output_ct += write(fd, &c, 1);
	}
	return (output_ct);
}

static int	ft_formats(va_list args, const char format)
{
	int		output_ct;

	output_ct = 0;
	if (format == 'c')
		output_ct += ft_putchar_fd(va_arg(args, int), 1);
	else if (format == 's')
		output_ct += ft_putstr_fd(va_arg(args, char *), 1);
	else if (format == 'p')
		output_ct += ft_putptr_fd((void *)va_arg(args, long long unsigned), 1);
	else if (format == 'i' || format == 'd')
		output_ct += ft_putnbr_fd(va_arg(args, int), 1);
	else if (format == 'u')
		output_ct += ft_putunsigned_fd(va_arg(args, unsigned int), 1);
	else if (format == 'x' || format == 'X')
		output_ct += ft_puthex_fd(va_arg(args, unsigned int), 1, format);
	else if (format == '%')
		output_ct += ft_putchar_fd('%', 1);
	return (output_ct);
}

int	ft_printf(const char *format, ...)
{
	int		i;
	int		output_ct;
	va_list	args;

	va_start(args, format);
	i = 0;
	output_ct = 0;
	while (format[i])
	{
		if (format[i] == '%')
		{
			output_ct += ft_formats(args, format[i + 1]);
			i++;
		}
		else
			output_ct += ft_putchar_fd(format[i], 1);
		i++;
	}
	va_end(args);
	return (output_ct);
}

/* int	main(void)
{
	printf("\n%d\n", printf(" %p %p ", NULL, NULL));
	printf("\n%d\n", ft_printf(" %p %p ", NULL, NULL));
	return (0);
} */
