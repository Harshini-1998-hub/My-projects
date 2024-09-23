import rclpy
import math

from rclpy.node import Node
from sensor_msgs.msg import LaserScan
from geometry_msgs.msg import Twist
from nav_msgs.msg import Odometry
from tf2_ros import TransformRegistration
from rclpy.qos import QoSProfile, ReliabilityPolicy




#global declarations for inputs (Front Right Sensors and Back Right Sensors)
global frs_low, frs_medium, frs_high, brs_low, brs_medium, brs_high

#global declarations for outputs (Linear and Angular)
global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left

#min value - FIRING STRENGTHS
global r1, r2, r3, r4, r5, r6, r7, r8, r9

#List Declaration for FRS and BRS inputs
frs_low=[]
frs_medium=[]
frs_high=[]
brs_low=[] 
brs_medium=[] 
brs_high=[]

#declaring linear_speed and angular_speed
global linear_speed_x, angular_speed_y

#Mapping the sensor readings into a dictionary
map_= {
    'frs_low':0, 
    'frs_medium':0, 
    'frs_high':0, 
    'brs_low':0, 
    'brs_medium':0, 
    'brs_high':0 
}


speed=[]



mynode_ = None
pub_ = None
regions_ = {
    'right': 0,
    'fright': 0,
    'front1': 0,
    'front2': 0,
    'fleft': 0,
    'left': 0,
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
        'fright': find_nearest (msg.ranges[310:320]),
        'fleft':  find_nearest (msg.ranges[40:50]),
        'right':  find_nearest(msg.ranges[265:275]),
        'left':   find_nearest (msg.ranges[85:95])
        
    }    
    twstmsg_= movement()

    
# Find nearest point
def find_nearest(list):
    f_list = filter(lambda item: item > 0.0, list)  # exclude zeros
    return min(min(f_list, default=10), 10)


#EDGE VALUE
def fuzzy_logic():

    #Declarations for inputs (Front Right Sensors and Back Right Sensors)
    global frs_low, frs_medium, frs_high, brs_low, brs_medium, brs_high

    #Declarations for inputs (Linear and Angular)
    global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left

    #min value - FIRING STRENGTHS
    global r1, r2, r3, r4, r5, r6, r7, r8, r9

    #declaring linear_speed and angular_speed
    global linear_speed_x, angular_speed_y

    #Define regions for FRS inputs
    frs_low = [0.0, 0.25, 0.5]
    frs_medium = [0.25, 0.5, 0.75]
    frs_high = [0.5, 0.75, 1]

    #Define regions for BRS outputs
    brs_low = [0.0, 0.25, 0.5]
    brs_medium = [0.25, 0.5, 0.75]
    brs_high = [0.5, 0.75, 1]

    #List to return Linear and Angular speed
    speed=[]

    # Linear output speed
    linear_slow = 0.075
    linear_medium = 0.225    
    linear_fast = 0.375

    #Angular output speed
    angular_right = -0.8
    angular_forward = 0.0
    angular_left = 0.4

    # dictionary to update the fuzzification values
    map_= {
        'frs_low':0, 
        'frs_medium':0, 
        'frs_high':0, 
        'brs_low':0, 
        'brs_medium':0, 
        'brs_high':0 
    }


    #Readings
    print(f"FRS(front right sensor value) is : {regions_['fright']}" )
    print(f"BRS(back right sensor value) is : {regions_['right']}" )
    print(f"FRS_LOW: {map_['frs_low']}    FRS_MEDIUM: {map_['frs_medium']}    FRS_HIGH: {map_['frs_high']}") 

    # FUZZIFICATION
    if (regions_['fright'] >= frs_low[0]) and (regions_['fright'] <= frs_low[1]):
        map_['frs_low'] = 1
        print('frs_low1')

    if(regions_['fright'] > frs_low[1]) and (regions_['fright'] <= frs_low[2]):
        map_['frs_low'] = ((frs_low[2] - regions_['fright']) / (frs_low[2] - frs_low[1]))
        print('frs_low2')

    if (regions_['fright'] >= frs_medium[0]) and (regions_['fright'] <= frs_medium[1]):
        map_['frs_medium'] = ((regions_['fright'] - frs_medium[0]) / (frs_medium[1] - frs_medium[0]))
        print('frs_medium1')

    if (regions_['fright'] > frs_medium[1]) and (regions_['fright'] <= frs_medium[2]):
        map_['frs_medium'] = ((frs_medium[2] - regions_['fright']) / (frs_medium[2] - frs_medium[1]))
        print('frs_medium2')

    if (regions_['fright'] >= frs_high[0]) and (regions_['fright'] <= frs_high[1]):
        map_['frs_high'] = ((regions_['fright'] - frs_high[0]) / (frs_high[1] - frs_high[0]))
        print('frs_high1')

    if (regions_['fright'] > frs_high[1]) :
        map_['frs_high'] = 1
        print('frs_high2')



    if (regions_['right'] >= brs_low[0]) and (regions_['right'] <= brs_low[1]):
        map_['brs_low'] = 1
        print('brs_low1')

    if (regions_['right'] > brs_low[1]) and (regions_['right'] <= brs_low[2]):
        map_['brs_low'] = ((brs_low[2] - regions_['right']) / (brs_low[2] - brs_low[1]))
        print('brs_low2')

    if (regions_['right'] >= brs_medium[0]) and (regions_['right'] <= brs_medium[1]):
        map_['brs_medium'] = ((regions_['right'] - brs_medium[0]) / (brs_medium[1] - brs_medium[0]))
        print('brs_medium1')

    if (regions_['right'] > brs_medium[1]) and (regions_['right'] <= brs_medium[2]):
        map_['brs_medium'] = ((brs_medium[2] - regions_['right']) / (brs_medium[2] - brs_medium[1]))
        print('brs_medium2')

    if (regions_['right'] >= brs_high[0]) and (regions_['right'] <= brs_high[1]):
        map_['brs_high'] = ((regions_['right'] - brs_high[0]) / (brs_high[1] - brs_high[0]))
        print('brs_high1')

    if (regions_['right'] > brs_high[1]) :
        map_['brs_high'] = 1
        print('brs_high2')


    #Firing Strengths
    r1 = ((map_['frs_low'])*(map_['brs_low']))
    print(f"r1: {r1}")

    r2 = ((map_['frs_low'])*(map_['brs_medium']))
    print(f"r2: {r2}")

    r3 = ((map_['frs_low'])*(map_['brs_high']))
    print(f"r3: {r3}")

    r4 = ((map_['frs_medium'])*(map_['brs_low']))
    print(f"r4: {r4}")

    r5 = ((map_['frs_medium'])*(map_['brs_medium']))
    print(f"r5: {r5}")

    r6 = ((map_['frs_medium'])*(map_['brs_high']))
    print(f"r6: {r6}")

    r7 = ((map_['frs_high'])*(map_['brs_low']))
    print(f"r7: {r7}")

    r8 = ((map_['frs_high'])*(map_['brs_medium']))
    print(f"r8: {r8}")

    r9 = ((map_['frs_high'])*(map_['brs_high']))
    print(f"r9: {r9}")

    # DEFUZZIFICATION USING CENTROID MEATHOD

    #Calculation of Linear speed
    linear_speed_x = ((r1 * linear_slow) + (r2 * linear_slow) + (r3 * linear_slow) + (r4 * linear_medium) + (r5 * linear_fast) + (r6 * linear_medium) + (r7 * linear_fast) + (r8 * linear_fast) + (r9 * linear_fast))/ (r1+r2+r3+r4+r5+r6+r7+r8+r9)
    print(f"linear speed {linear_speed_x}")

    #Calculation of Angular speed
    angular_speed_y = ((r1 * angular_left) + (r2 * angular_left) + (r3 * angular_left) + (r4 * angular_forward) + (r5 * angular_forward) + (r6 * angular_forward) + (r7 * angular_forward) + (r8 * angular_right) + (r9 * angular_right))/ (r1+r2+r3+r4+r5+r6+r7+r8+r9)
    print(f"angular speed {angular_speed_y}")

    #Return Linear and Angular speed
    speed.append(linear_speed_x)
    speed.append(angular_speed_y)
    print(f"FRS_LOW: {map_['frs_low']}    FRS_MEDIUM: {map_['frs_medium']}    FRS_HIGH: {map_['frs_high']}") 
    print(speed)
    return speed




#Basic movement method
def movement():
    #print("here")
    global regions_, mynode_, regions
    regions = regions_
    
    
    
    #create an object of twist class, used to express the linear and angular velocity of the turtlebot 
    msg = Twist()
    

    msg.linear.x = fuzzy_logic()[0]
    msg.angular.z = fuzzy_logic()[1]
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