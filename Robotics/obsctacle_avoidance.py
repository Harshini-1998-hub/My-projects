import rclpy
import math

from rclpy.node import Node
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
from nav_msgs.msg import Odometry
from tf2_ros import TransformRegistration
from rclpy.qos import QoSProfile, ReliabilityPolicy




#global declarations for inputs (Front Right Sensors, Back Right Sensors and Front sensor values)
global frnt1_low, frnt1_medium, frnt1_high, frnt2_low, frnt2_medium, frnt2_high, frnt3_low, frnt3_medium, frnt3_high

#global declarations for outputs (Linear and Angular)
global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left

#min value - FIRING STRENGTHS
global r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27

#List Declaration for FRS,BRS anf FRONT SENSOR inputs
frnt1_low=[]
frnt1_medium=[]
frnt1_high=[]
frnt2_low=[] 
frnt2_medium=[] 
frnt2_high=[]
frnt3_low = []
frnt3_medium = []
frnt3_high = []

#declaring linear_speed and angular_speed
global linear_speed_x, angular_speed_y

#Mapping the sensor readings into a dictionary
map_= {
    'frnt1_low' :0,
    'frnt1_medium' :0,
    'frnt1_high': 0,
    'frnt2_low':0, 
    'frnt2_medium':0, 
    'frnt2_high':0, 
    'frnt3_low':0, 
    'frnt3_medium':0, 
    'frnt3_high':0 
}

# list to update linear and angular speed
speed=[]

mynode_ = None
pub_ = None
regions_ = {
    'front1': 0,
    'front2': 0,
    'fright': 0,
    'fleft' : 0,
    'right':  0,
    'left': 0

}

twstmsg_ = None

# main function attached to timer callback
def timer_callback():
    global pub_, twstmsg_
    if ( twstmsg_ != None ):
        pub_.publish(twstmsg_)



def clbk_laser(msg):
    global regions_, twstmsg_
    
    regions_ = {
        #LIDAR readings are anti-clockwise
        'front1':  find_nearest (msg.ranges[0:5]),
        'front2':  find_nearest (msg.ranges[355:360]),
        'fright': find_nearest (msg.ranges[310:350]),
        'fleft':  find_nearest (msg.ranges[15:50]),
        'right':  find_nearest(msg.ranges[265:275]),
        'left':   find_nearest (msg.ranges[85:95])
        
    }    
    twstmsg_= movement()


    
# Find nearest point
def find_nearest(list):
    f_list = filter(lambda item: item > 0.0, list)  # exclude zeros
    return min(min(f_list, default=10), 10)



# OBSTACLE AVOIDANCE
def obstacle_avoidance():

    #Declarations for inputs (Front Right Sensors, Back Right Sensors and Front sensors)
    global frnt1_low, frnt1_medium, frnt1_high, frnt2_low, frnt2_medium, frnt2_high, frnt3_low, frnt3_medium, frnt3_high

    #Declarations for inputs (Linear and Angular)
    global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left

    #min value - FIRING STRENGTHS
    global r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27

    #declaring linear_speed and angular_speed
    global linear_speed_x, angular_speed_y


    
    #Define regions for FS inputs
    frnt1_low = [0.0, 0.25, 0.6]
    frnt1_medium = [0.25, 0.6, 0.7]
    frnt1_high = [0.6, 0.7, 1]

    #Define regions for FRS inputs
    frnt2_low = [0.0, 0.25, 0.75]
    frnt2_medium = [0.25, 0.75, 0.85]
    frnt2_high = [0.75, 0.85, 1]

    #Define regions for BRS outputs
    frnt3_low = [0.0, 0.25, 0.6]
    frnt3_medium = [0.25, 0.6, 0.7]
    frnt3_high = [0.6, 0.7, 1]

    #List to return Linear and Angular speed
    speed=[]

    # Linear output speed
    linear_slow = 0.05
    linear_medium = 0.1
    linear_fast = 0.15

    #Angular output speed
    angular_right = -0.8
    angular_forward = 0.0
    angular_left = 0.8

    
    # Dictionary to update fuzzification values
    map_= {
        'frnt1_low' :0,
        'frnt1_medium' :0,
        'frnt1_high': 0,
        'frnt2_low':0, 
        'frnt2_medium':0, 
        'frnt2_high':0, 
        'frnt3_low':0, 
        'frnt3_medium':0, 
        'frnt3_high':0 
    }


    #Readings

    print(f"Front1 sesonr value is : {regions_['fleft']}" )
    print(f"Front3 sensor value is : {regions_['fright']}" )
  

    # FUZZIFICATION 
    if (regions_['fleft'] >= frnt1_low[0]) and (regions_['fleft'] <= frnt1_low[1]):
        map_['frnt1_low'] = 1
        print('frnt1_low1')

    if (regions_['fleft']  > frnt1_low[1]) and (regions_['fleft'] <= frnt1_low[2]):
        map_['frnt1_low'] = (frnt1_low[2] - (regions_['fleft'])) / (frnt1_low[2] - frnt1_low[1])
        print('frnt1_low2')

    if (regions_['fleft'] >= frnt1_medium[0]) and (regions_['fleft'] <= frnt1_medium[1]):
        map_['frnt1_medium'] = (regions_['fleft'] - frnt1_medium[0]) / (frnt1_medium[1] - frnt1_medium[0])
        print('frnt1_medium1')

    if (regions_['fleft']  > frnt1_medium[1]) and (regions_['fleft'] <= frnt1_medium[2]):
        map_['frnt1_medium'] = (frnt1_medium[2]-regions_['fleft']) / (frnt1_medium[2] - frnt1_medium[1])
        print('frnt1_medium2')

    if (regions_['fleft'] >= frnt1_high[0]) and (regions_['fleft'] <= frnt1_high[1]):
        map_['frnt1_high'] = (regions_['fleft'] - frnt1_high[0]) / (frnt1_high[1] - frnt1_high[0])
        print('frnt1_high1')

    if (regions_['fleft'] > frnt1_high[1]) :
        map_['frnt1_high'] = 1
        print('frnt1_high2')



    if (((regions_['front1'] + regions_['front2'])/2) >= frnt2_low[0]) and (((regions_['front1'] + regions_['front2'])/2) <= frnt2_low[1]):
        map_['frnt2_low'] = 1
        print('frnt2_low1')

    if (((regions_['front1'] + regions_['front2'])/2) > frnt2_low[1]) and (((regions_['front1'] + regions_['front2'])/2) <= frnt2_low[2]):
        map_['frnt2_low'] = (frnt2_low[2] - ((regions_['front1'] + regions_['front2'])/2)) / (frnt2_low[2] - frnt2_low[1])
        print('frnt2_low2')

    if (((regions_['front1'] + regions_['front2'])/2) >= frnt2_medium[0]) and (((regions_['front1'] + regions_['front2'])/2) <= frnt2_medium[1]):
        map_['frnt2_medium'] = (((regions_['front1'] + regions_['front2'])/2) - frnt2_medium[0]) / (frnt2_medium[1] - frnt2_medium[0])
        print('frnt2_medium1')

    if (((regions_['front1'] + regions_['front2'])/2)  > frnt2_medium[1]) and (((regions_['front1'] + regions_['front2'])/2) <= frnt2_medium[2]):
        map_['frnt2_medium'] = (frnt2_medium[2]-(regions_['front1'] + regions_['front2'])/2) / (frnt2_medium[2] - frnt2_medium[1])
        print('frnt2_medium2')

    if (((regions_['front1'] + regions_['front2'])/2) >= frnt2_high[0]) and (((regions_['front1'] + regions_['front2'])/2)<= frnt2_high[1]):
        map_['frnt2_high'] = (((regions_['front1'] + regions_['front2'])/2)- frnt2_high[0]) / (frnt2_high[1] - frnt2_high[0])
        print('frnt2_high1')

    if (((regions_['front1'] + regions_['front2'])/2) > frnt2_high[1]):
        map_['frnt2_high'] = 1
        print('frnt2_high2')



    if (regions_['fright'] >= frnt3_low[0]) and (regions_['fright'] <= frnt3_low[1]):
        map_['frnt3_low'] = 1
        print('frnt3_low1')

    if (regions_['fright']  > frnt3_low[1]) and (regions_['fright'] <= frnt3_low[2]):
        map_['frnt3_low'] = (frnt3_low[2] - (regions_['fright'])) / (frnt3_low[2] - frnt3_low[1])
        print('frnt3_low2')

    if (regions_['fright'] >= frnt3_medium[0]) and (regions_['fright'] <= frnt3_medium[1]):
        map_['frnt3_medium'] = (regions_['fright'] - frnt3_medium[0]) / (frnt3_medium[1] - frnt3_medium[0])
        print('frnt3_medium1')

    if (regions_['fright']  > frnt3_medium[1]) and (regions_['fright'] <= frnt3_medium[2]):
        map_['frnt3_medium'] = (frnt3_medium[2]-regions_['fright']) / (frnt3_medium[2] - frnt3_medium[1])
        print('frnt3_medium2')

    if (regions_['fright'] >= frnt3_high[0]) and (regions_['fright'] <= frnt3_high[1]):
        map_['frnt3_high'] = (regions_['fright'] - frnt3_high[0]) / (frnt3_high[1] - frnt3_high[0])
        print('frnt3_high1')

    if (regions_['fright'] > frnt3_high[1]):
        map_['frnt3_high'] = 1
        print('frnt3_high2')


    #Firing Strengths
    r1 = min((map_['frnt1_low']),(map_['frnt2_low']),(map_['frnt3_low']))
    print(f"r1: {r1}")

    r2 = min((map_['frnt1_low']),(map_['frnt2_low']),(map_['frnt3_medium']))
    print(f"r2: {r2}")

    r3 = min((map_['frnt1_low']),(map_['frnt2_low']),(map_['frnt3_high']))
    print(f"r3: {r3}")

    r4 = min((map_['frnt1_low']),(map_['frnt2_medium']),(map_['frnt3_low']))
    print(f"r4: {r4}")

    r5 = min((map_['frnt1_low']),(map_['frnt2_medium']),(map_['frnt3_medium']))
    print(f"r5: {r5}")

    r6 = min((map_['frnt1_low']),(map_['frnt2_medium']),(map_['frnt3_high']))
    print(f"r6: {r6}")

    r7 = min((map_['frnt1_low']),(map_['frnt2_high']),(map_['frnt3_low']))
    print(f"r6: {r6}")

    r8 = min((map_['frnt1_low']),(map_['frnt2_high']),(map_['frnt3_medium']))
    print(f"r8: {r8}")

    r9 = min((map_['frnt1_low']),(map_['frnt2_high']),(map_['frnt3_high']))
    print(f"r9: {r9}")



    r10 = min((map_['frnt1_medium']),(map_['frnt2_low']),(map_['frnt3_low']))
    print(f"r10: {r10}")

    r11 = min((map_['frnt1_medium']),(map_['frnt2_low']),(map_['frnt3_medium']))
    print(f"r11: {r11}")

    r12 = min((map_['frnt1_medium']),(map_['frnt2_low']),(map_['frnt3_high']))
    print(f"r12: {r12}")

    r13 = min((map_['frnt1_medium']),(map_['frnt2_medium']),(map_['frnt3_low']))
    print(f"r13: {r13}")

    r14 = min((map_['frnt1_medium']),(map_['frnt2_medium']),(map_['frnt3_medium']))
    print(f"r14: {r14}")

    r15 = min((map_['frnt1_medium']),(map_['frnt2_medium']),(map_['frnt3_high']))
    print(f"r15: {r15}")

    r16 = min((map_['frnt1_medium']),(map_['frnt2_high']),(map_['frnt3_low']))
    print(f"r16: {r16}")

    r17 = min((map_['frnt1_medium']),(map_['frnt2_high']),(map_['frnt3_medium']))
    print(f"r17: {r17}")

    r18 = min((map_['frnt1_medium']),(map_['frnt2_high']),(map_['frnt3_high']))
    print(f"r18: {r18}")

    

    r19 = min((map_['frnt1_high']),(map_['frnt2_low']),(map_['frnt3_low']))
    print(f"r19: {r19}")

    r20 = min((map_['frnt1_high']),(map_['frnt2_low']),(map_['frnt3_medium']))
    print(f"r20: {r20}")

    r21 = min((map_['frnt1_high']),(map_['frnt2_low']),(map_['frnt3_high']))
    print(f"r21: {r21}")

    r22 = min((map_['frnt1_high']),(map_['frnt2_medium']),(map_['frnt3_low']))
    print(f"r22: {r22}")

    r23 = min((map_['frnt1_high']),(map_['frnt2_medium']),(map_['frnt3_medium']))
    print(f"r23: {r23}")

    r24 = min((map_['frnt1_high']),(map_['frnt2_medium']),(map_['frnt3_high']))
    print(f"r24: {r24}")

    r25 = min((map_['frnt1_high']),(map_['frnt2_high']),(map_['frnt3_low']))
    print(f"r25: {r25}")

    r26 = min((map_['frnt1_high']),(map_['frnt2_high']),(map_['frnt3_medium']))
    print(f"r26: {r26}")

    r27 = min((map_['frnt1_high']),(map_['frnt2_high']),(map_['frnt3_high']))
    print(f"r27: {r27}")

    # DEFUZZIFICATION 
    #Calculation of Linear speed
    linear_speed_x = ((r1 * linear_slow) + (r2 * linear_slow) + (r3 * linear_slow) + (r4 * linear_slow) + (r5 * linear_slow) + (r6 * linear_slow) + (r7 * linear_slow) + (r8 * linear_slow) + (r9 * linear_slow) + (r10 * linear_slow) + (r11 * linear_slow) + (r12 * linear_slow) + (r13 * linear_slow) + (r14 * linear_slow) + (r15 * linear_slow) + (r16 * linear_slow) + (r17 * linear_slow) + (r18 * linear_slow) + (r19 * linear_slow) + (r20 * linear_slow) + (r21 * linear_slow) + (r22 * linear_slow) + (r23 * linear_slow) + (r24 * linear_slow) + (r25 * linear_slow) + (r26 * linear_medium) + (r27 * linear_fast))/ (r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15+r16+r17+r18+r19+r20+r21+r22+r23+r24+r25+r26+r27)
    print(f"linear speed {linear_speed_x}")

    #Calculation of Angular speed
    angular_speed_y = ((r1 * angular_left) + (r2 * angular_right) + (r3 * angular_right) + (r4 * angular_left) + (r5 * angular_right) + (r6 * angular_right) + (r7 * angular_left) + (r8 * angular_right) + (r9 * angular_right) + (r10 * angular_left) + (r11 * angular_left) + (r12 * angular_right) + (r13 * angular_left) + (r14 * angular_left) + (r15 * angular_right) + (r16 * angular_left) + (r17 * angular_left) + (r18 * angular_right) + (r19 * angular_left) + (r20 * angular_left) + (r21 * angular_left) + (r22 * angular_left) + (r23 * angular_left) + (r24 * angular_left) + (r25 * angular_left) + (r26 * angular_left) + (r27 * angular_forward) )/ (r1+r2+r3+r4+r5+r6+r7+r8+r9+r10+r11+r12+r13+r14+r15+r16+r17+r18+r19+r20+r21+r22+r23+r24+r25+r26+r27)
    print(f"angular speed {angular_speed_y}")

    #Return Linear and Angular speed
    speed.append(linear_speed_x)
    speed.append(angular_speed_y)
    print(speed)
    return speed



def movement():
    #print("here")
    global regions_, mynode_
    regions = regions_
    
    #print("Min distance in front region: ", regions_['front1'],regions_['front2'])
    print("CHECK", (regions_['front1'] ))
    print("CHECK",(regions_['front2'] ))
    print("CHECK",(regions_['front1'] + regions_['front2']) / 2)
    print("Actual", (regions_['front1']+regions_['front2']))
    
    #create an object of twist class, used to express the linear and angular velocity of the turtlebot 
    msg = Twist()
    

    msg.linear.x = obstacle_avoidance()[0]
    msg.angular.z = obstacle_avoidance()[1]
    return msg
    

    
#used to stop the rosbot
def stop():
    global pub_
    msg = Twist()
    msg.angular.z = 0.0
    msg.linear.x = 0.0
    pub_.publish(msg)


def main():
    global pub_, mynode_

    rclpy.init()
    mynode_ = rclpy.create_node('reading_laser')

    # define qos profile (the subscriber default 'reliability' is not compatible with robot publisher 'best effort')
    qos = QoSProfile(
        depth=10,
        reliability=ReliabilityPolicy.BEST_EFFORT,
    )

    # publisher for twist velocity messages (default qos depth 10)
    pub_ = mynode_.create_publisher(Twist, '/cmd_vel', 10)

    # subscribe to laser topic (with our qos)
    sub = mynode_.create_subscription(LaserScan, '/scan', clbk_laser, qos)

    # Configure timer
    timer_period = 0.2  # seconds 
    timer = mynode_.create_timer(timer_period, timer_callback)

    # Run and handle keyboard interrupt (ctrl-c)
    try:
        rclpy.spin(mynode_)
    except KeyboardInterrupt:
        stop()  # stop the robot
    except:
        stop()  # stop the robot
    finally:
        # Clean up
        mynode_.destroy_timer(timer)
        mynode_.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()