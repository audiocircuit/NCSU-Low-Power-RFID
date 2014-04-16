file = open('EEPROM.txt','w')

for j in range(0,5):
    for i in range(0,255):
        file.write(str(format((4096-i),"x")) + "\n")
    for i in range(0,(4096-255)):
        file.write("xxxx" + "\n")

file.close()
