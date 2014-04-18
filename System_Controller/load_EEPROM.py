file = open('EEPROM.txt','w')

#=========Write Lookup Table
for j in range(1,5):
    for i in range(1,257):
        file.write(str(format((4096-i),"x")) + "\n")
    for i in range(256,4096):
        file.write("xxxx" + "\n")

#=========Write Sensor addr/control byte and validity check
#Sensor 0
file.write(str(format(int('0101010100100010',2),"x")) + "\n")
file.write("aaaa\n")

for j in range(3,17):
    file.write("xxxx\n")

#Sensor 1
file.write(str(format(int('1010101000100110',2),"x")) + "\n")
file.write("aaaa\n")

for j in range(3,17):
    file.write("xxxx\n")

#Sensor 2
file.write(str(format(int('0011001100101001',2),"x")) + "\n")
file.write("aaaa\n")

for j in range(3,17):
    file.write("xxxx\n")

#Sensor 3
file.write(str(format(int('1100110000101010',2),"x")) + "\n")
file.write("aaaa\n")

for j in range(3,17):
    file.write("xxxx\n")

file.close()
