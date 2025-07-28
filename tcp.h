/*
 *  tcp.h
 *  Noise
 *
 *  Created by Jake on 7/24/25.
 *  Copyright 2025 __MyCompanyName__. All rights reserved.
 *
 */
#import <unistd.h>
#import <stdbool.h>

typedef int socket_descriptor;

socket_descriptor init_tcp(const char * ip, int port);
bool send_tcp(const char * message, socket_descriptor sock);
void close_tcp(socket_descriptor sock);
bool recv_tcp(socket_descriptor sock, void (* handler) (char *));