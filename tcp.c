/*
 *  tcp.c
 *  Noise
 *
 *  Created by Jake on 7/24/25.
 *  Copyright 2025 __MyCompanyName__. All rights reserved.
 *
 */

#import "tcp.h"
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/select.h>
#import <netinet/in.h>
#import <netinet/tcp.h>
#import <string.h>
#import <pthread.h>
#import <stdlib.h>
#import <stdio.h>
#import <fcntl.h>
#import <errno.h>

unsigned char crlf[2] = {0x0D, 0x0A};

bool recv_tcp(socket_descriptor sock, void (* handler) (char *)) {
	char buffer[2048];
	memset(buffer, NULL, sizeof(buffer));
	int total = 0;
	while (1) {
		fd_set read_fds;
		FD_ZERO(&read_fds);
		FD_SET(sock, &read_fds);
		
		int activity = select(sock + 1, &read_fds, NULL, NULL, NULL);
		if (activity < 0) {
			return false;
		}
		if (FD_ISSET(sock, &read_fds)) {
			
			char c;
			int bytes = read(sock, &c, 1);
			if (bytes <= 0) {
				return true;
			}
			if (total < sizeof(buffer))
				buffer[total++] = c;
			if (c == '\n') {
				buffer[total] = '\0';
				// call function to handle
				// handler must copy string before spawning new thread as we will overwrite the buffer 
				handler(buffer);
				total = 0;
			}
		}
	}
}

socket_descriptor init_tcp(const char * ip, int port) {
	int socket_dsc;
	struct sockaddr_in server_addr;
	
	// create socket
	socket_dsc = socket(AF_INET, SOCK_STREAM, 0);
	
	// check creation
	if (socket_dsc < 0) {
		//printf("%s", "Socket creation failed.\n");
		return -1;
	}
	//printf("%s", "Socket created successfully.\n");
	
	// set IP and port
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port); // TODO: replace with config data
	server_addr.sin_addr.s_addr = inet_addr(ip);
	
	int res, opt;
	
	// get socket config
	if ((opt = fcntl (socket_dsc, F_GETFL, NULL)) < 0) {
		return -1;
	}
	
	// set nonblocking
	if (fcntl(socket_dsc, F_SETFL, opt | O_NONBLOCK) < 0) {
		return -1;
	}
	
	// start connection
	struct timeval timeout;
	timeout.tv_sec = 10;
	timeout.tv_usec = 0;
	if ((res = connect(socket_dsc, (struct sockaddr *) &server_addr, sizeof(server_addr))) < 0) {
		if (errno == EINPROGRESS) {
			fd_set wait_set;
			FD_ZERO(& wait_set);
			FD_SET(socket_dsc, & wait_set);
			res = select(socket_dsc + 1, NULL, & wait_set, NULL, & timeout);
			
		}
		
		else return -1;
	}
	else {
		res = 1;
	}
	
	// reset socket flags
	if (fcntl(socket_dsc, F_SETFL, opt) < 0) {
		return -1;
	}
	
	if (res <= 0) {
		return -1;
	}
	int flag = 1;
	setsockopt(socket_dsc, IPPROTO_TCP, TCP_NODELAY, &flag, sizeof(int));
	
	return socket_dsc;
}

bool send_tcp(const char * message, socket_descriptor sock) {
	if (write(sock, message, strlen(message)) < 0) {
		return false;
	}
	write(sock, crlf, 2);
	return true;
}



void close_tcp(socket_descriptor sock) {
	close(sock);
}
