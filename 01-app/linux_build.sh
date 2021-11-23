#! /bin/bash

#---Definitions---#
CC=cc
INSTALL_PREFIX=../out

#---Create directories---#
mkdir -p ${INSTALL_PREFIX}

#---Build---#
${CC} -Wall -Werror					\
	$(pkg-config --cflags libpq)	\
	-o${INSTALL_PREFIX}/app			\
	./main.c						\
	$(pkg-config --libs libpq)
