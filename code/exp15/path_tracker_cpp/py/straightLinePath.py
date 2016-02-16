#!/usr/bin/python

pathFileName = '../data/straight_line_path.txt'
f = open(pathFileName,'w')
dt = 0.05 # in s
duration = 20 # in s
speed = 0.5 # in m/s
yawRate = 0.0 # in rad/s
t = 0.0
x = 0.0
y = 0.0
while t < duration:
    ds = speed*dt
    condn = ds >= 0.01
    if not condn:
        raise ValueError('Resolution has to be greater than 0.01')
    x = x + speed*dt
    line = "%.3f,%.3f,%.3f,%.3f\n" % (x,y,speed,yawRate)
    f.write(line)
    t = t + dt
    
f.close()
