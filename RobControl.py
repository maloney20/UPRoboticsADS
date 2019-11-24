import socket
import json
import threading
import math


serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = '127.0.0.1'
port = 9001
serversocket.bind((host, port))
serversocket.listen(5)
print("server listening on port ", port)
(clientsocket, address) = serversocket.accept()
print("robot connected")


try:
	clientsocket.send("GO&".encode())
	clientsocket.send("".encode())
	turning = False;
	savedMax = 0;
	while True:
		threshold = 100
		rawJson = clientsocket.recv(4096).decode(encoding="UTF-8")
		
		points = json.loads(rawJson)
		print("right in front "+str(points["0.0"]))
		#print(points)
		if not turning:
			for ang in points:
				#print(points[ang])
				if points[ang]< threshold:
					print("ahhh stop stop stop")
					clientsocket.sendall("STOP&".encode())
					clientsocket.send("".encode())
					newDirection = "0.0"
					for ang in points:
						if points[ang] > points[newDirection]:
							newDirection = ang
					savedMax = points[newDirection]
					if float(newDirection) < 2*math.pi:
						print("Turn left")
						clientsocket.sendall("TURN_L&".encode())
						clientsocket.send("".encode())

						turning = True
					else:
						print("Turn right")
						clientsocket.sendall("TURN_R&".encode())
						clientsocket.send("".encode())

						turning = True
		elif points["0.0"] > threshold:
			clientsocket.sendall("STOP&".encode())
			clientsocket.send("".encode())
			clientsocket.sendall("GO&".encode())
			clientsocket.send("".encode())
			turning = False
		else:
			print(savedMax)




except Exception as e:
	print(e)
finally:
	serversocket.close()
