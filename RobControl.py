import socket

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = '127.0.0.1'
port = 9001
serversocket.bind((host, port))
serversocket.listen(5)
print("server listening on port ", port)
(clientsocket, address) = serversocket.accept()
print("robot connected")
command = ""
while command != 'QUIT':
	print("command: ", end="")
	command = input()
	command = command.upper()
	clientsocket.send(command.encode())
	print("sent: ", command)
#	points = socket.recv()
serversocket.close()
