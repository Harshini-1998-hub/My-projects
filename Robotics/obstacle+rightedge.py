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
#global declarations for inputs (Front Right Sensors, Back Right Sensors and Front sensor values)
global frnt1_low, frnt1_medium, frnt1_high, frnt2_low, frnt2_medium, frnt2_high, frnt3_low, frnt3_medium, frnt3_high



# FUZZY - global declarations for outputs (Linear and Angular)
global linear_slow_rightedge, linear_medium_rightedge, linear_fast_rightedge, angular_right_rightedge, angular_forward_rightedge, angular_left_rightedge
# OBSTACLE - global declarations for outputs (Linear and Angular)
global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left


# FUZZY - min value - FIRING STRENGTHS
global r1_rightedge, r2_rightedge, r3_rightedge, r4_rightedge, r5_rightedge, r6_rightedge, r7_rightedge, r8_rightedge, r9_rightedge
# OBSTACLE - min value - FIRING STRENGTHS
global r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27



# FUZZY LOGIC - List Declaration for FRS and BRS inputs
frs_low=[]
frs_medium=[]
frs_high=[]
brs_low=[] 
brs_medium=[] 
brs_high=[]

# OBSTACLE - List Declaration for FRS,BRS and FRONT SENSOR inputs
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
global linear_speed_x_rightedge, angular_speed_y_rightedge
#declaring linear_speed and angular_speed
global linear_speed_x, angular_speed_y



#COMBINATION (obstacle + rightedge)
global d1_obstacle, d2_rightedge, d1_region_obstacle, d2_region_rightedge, LMS_re, RMS_re, LMS_oa, RMS_oa, LMS_combination, RMS_combination

#initializing the list
d1_region_obstacle = []
d2_region_rightedge = []
d3_region_goalseek = []


# RIGHT EDGE - Mapping the sensor readings into a dictionary
map_rightedge= {
    'frs_low':0, 
    'frs_medium':0, 
    'frs_high':0, 
    'brs_low':0, 
    'brs_medium':0, 
    'brs_high':0 
}

#list to append linear and angular speeds
speed_rightedge=[]

# OBSTACLE - Mapping the sensor readings into a dictionary
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

#list to append linera and angular speed
speed=[]

#OBSTACLE, RIGHT-EDGE andCombination
global map_combination

map_combination = {
    'M_d1_obstacle': 0,
    'M_d2_rightedge':0, 
}
speed_comination = []


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





#EDGE VALUE
def right_edge():
  
    #Declarations for inputs (Front Right Sensors and Back Right Sensors)
    global frs_low, frs_medium, frs_high, brs_low, brs_medium, brs_high, map_rightedge

    #Declarations for inputs (Linear and Angular)
    global linear_slow_rightedge, linear_medium_rightedge, linear_fast_rightedge, angular_right_rightedge, angular_forward_rightedge, angular_left_rightedge

    #min value - FIRING STRENGTHS
    global r1_rightedge, r2_rightedge, r3_rightedge, r4_rightedge, r5_rightedge, r6_rightedge, r7_rightedge, r8_rightedge, r9_rightedge

    #declaring linear_speed and angular_speed
    global linear_speed_x_rightedge, angular_speed_y_rightedge

    #Define regions for FRS inputs
    frs_low = [0.0, 0.25, 0.5]
    frs_medium = [0.25, 0.5, 0.75]
    frs_high = [0.5, 0.75, 1]

    #Define regions for BRS outputs
    brs_low = [0.0, 0.25, 0.5]
    brs_medium = [0.25, 0.5, 0.75]
    brs_high = [0.5, 0.75, 1]

    #List to return Linear and Angular speed
    speed_rightedge=[]

    # Linear output speed
    linear_slow_rightedge = 0.05
    linear_medium_rightedge = 0.1    
    linear_fast_rightedge = 0.15

    #Angular output speed
    angular_right_rightedge = -0.8
    angular_forward_rightedge = 0.0
    angular_left_rightedge = 0.4

    #initialize dictionary values to 0 - This is used to store values of the FUZZIFICATION
    map_rightedge= {
        'frs_low':0, 
        'frs_medium':0, 
        'frs_high':0, 
        'brs_low':0, 
        'brs_medium':0, 
        'brs_high':0 
    }

    # FUZZIFICATION 
    print(f"FRS(front right sensor value) is : {regions_['fright']}" )
    print(f"BRS(back right sensor value) is : {regions_['right']}" )
    print(f"FRS_LOW: {map_rightedge['frs_low']}    FRS_MEDIUM: {map_rightedge['frs_medium']}    FRS_HIGH: {map_rightedge['frs_high']}") 

    # FUZZIFICATION FOR FRONT RIGHT SENSOR

    # When fright sensor readings is from frs_low[0] to frs_low[1] --> value remains 1
    if (regions_['fright'] >= frs_low[0]) and (regions_['fright'] <= frs_low[1]):
        map_rightedge['frs_low'] = 1
        print('frs_low1')

    # When fright sensor readings is from frs_low[1] to frs_low[2] --> Falling edge 
    if(regions_['fright'] > frs_low[1]) and (regions_['fright'] <= frs_low[2]):
        map_rightedge['frs_low'] = ((frs_low[2] - regions_['fright']) / (frs_low[2] - frs_low[1]))
        print('frs_low2')

    # When fright sensor readings is from frs_med[0] to frs_med[1] --> raising edge
    if (regions_['fright'] >= frs_medium[0]) and (regions_['fright'] <= frs_medium[1]):
        map_rightedge['frs_medium'] = ((regions_['fright'] - frs_medium[0]) / (frs_medium[1] - frs_medium[0]))
        print('frs_medium1')

    # When fright sensor readings is from frs_med[1] to frs_med[2] --> Falling edge 
    if (regions_['fright'] > frs_medium[1]) and (regions_['fright'] <= frs_medium[2]):
        map_rightedge['frs_medium'] = ((frs_medium[2] - regions_['fright']) / (frs_medium[2] - frs_medium[1]))
        print('frs_medium2')

    # When fright sensor readings is from frs_high[0] to frs_high[1] --> raising edge
    if (regions_['fright'] >= frs_high[0]) and (regions_['fright'] <= frs_high[1]):
        map_rightedge['frs_high'] = ((regions_['fright'] - frs_high[0]) / (frs_high[1] - frs_high[0]))
        print('frs_high1')

    # When fright sensor readings are greater that frs_high[1] --> value remains 1
    if (regions_['fright'] > frs_high[1]) :
        map_rightedge['frs_high'] = 1
        print('frs_high2')


    # FUZZIFICATION FOR FRONT RIGHT SENSOR
    # These are same as FRS calculations

    if (regions_['right'] >= brs_low[0]) and (regions_['right'] <= brs_low[1]):
        map_rightedge['brs_low'] = 1
        print('brs_low1')

    if (regions_['right'] > brs_low[1]) and (regions_['right'] <= brs_low[2]):
        map_rightedge['brs_low'] = ((brs_low[2] - regions_['right']) / (brs_low[2] - brs_low[1]))
        print('brs_low2')

    if (regions_['right'] >= brs_medium[0]) and (regions_['right'] <= brs_medium[1]):
        map_rightedge['brs_medium'] = ((regions_['right'] - brs_medium[0]) / (brs_medium[1] - brs_medium[0]))
        print('brs_medium1')

    if (regions_['right'] > brs_medium[1]) and (regions_['right'] <= brs_medium[2]):
        map_rightedge['brs_medium'] = ((brs_medium[2] - regions_['right']) / (brs_medium[2] - brs_medium[1]))
        print('brs_medium2')

    if (regions_['right'] >= brs_high[0]) and (regions_['right'] <= brs_high[1]):
        map_rightedge['brs_high'] = ((regions_['right'] - brs_high[0]) / (brs_high[1] - brs_high[0]))
        print('brs_high1')

    if (regions_['right'] > brs_high[1]) :
        map_rightedge['brs_high'] = 1
        print('brs_high2')


    # FIRING STRENGTHS and DEFINING RULES

    # Firing strengths are calculated my taking product of fuzzinfication values  
    r1_rightedge = ((map_rightedge['frs_low'])*(map_rightedge['brs_low']))
    print(f"r1_rightedge: {r1_rightedge}")

    r2_rightedge = ((map_rightedge['frs_low'])*(map_rightedge['brs_medium']))
    print(f"r2_rightedge: {r2_rightedge}")

    r3_rightedge = ((map_rightedge['frs_low'])*(map_rightedge['brs_high']))
    print(f"r3_rightedge: {r3_rightedge}")

    r4_rightedge = ((map_rightedge['frs_medium'])*(map_rightedge['brs_low']))
    print(f"r4_rightedge: {r4_rightedge}")

    r5_rightedge = ((map_rightedge['frs_medium'])*(map_rightedge['brs_medium']))
    print(f"r5_rightedge: {r5_rightedge}")

    r6_rightedge = ((map_rightedge['frs_medium'])*(map_rightedge['brs_high']))
    print(f"r6_rightedge: {r6_rightedge}")

    r7_rightedge = ((map_rightedge['frs_high'])*(map_rightedge['brs_low']))
    print(f"r7_rightedge: {r7_rightedge}")

    r8_rightedge = ((map_rightedge['frs_high'])*(map_rightedge['brs_medium']))
    print(f"r8_rightedge: {r8_rightedge}")

    r9_rightedge = ((map_rightedge['frs_high'])*(map_rightedge['brs_high']))
    print(f"r9_rightedge: {r9_rightedge}")


    # DEFUZZINFICATION USING CENTROID MEATHOD

    #Calculation of Linear speed --> multiplying firing strengths with the output rules
    linear_speed_x_rightedge = ((r1_rightedge * linear_slow_rightedge) + (r2_rightedge * linear_slow_rightedge) + (r3_rightedge * linear_slow_rightedge) + (r4_rightedge * linear_medium_rightedge) + (r5_rightedge * linear_medium_rightedge) + (r6_rightedge * linear_medium_rightedge) + (r7_rightedge * linear_fast_rightedge) + (r8_rightedge * linear_fast_rightedge) + (r9_rightedge * linear_fast_rightedge))/ (r1_rightedge+r2_rightedge+r3_rightedge+r4_rightedge+r5_rightedge+r6_rightedge+r7_rightedge+r8_rightedge+r9_rightedge)
    print(f"linear speed {linear_speed_x_rightedge}")

    #Calculation of Angular speed --> multiplying firing strengths with the input rules
    angular_speed_y_rightedge = ((r1_rightedge * angular_left_rightedge) + (r2_rightedge * angular_left_rightedge) + (r3_rightedge * angular_left_rightedge) + (r4_rightedge * angular_forward_rightedge) + (r5_rightedge * angular_forward_rightedge) + (r6_rightedge * angular_forward_rightedge) + (r7_rightedge * angular_forward_rightedge) + (r8_rightedge * angular_right_rightedge) + (r9_rightedge * angular_right_rightedge))/ (r1_rightedge+r2_rightedge+r3_rightedge+r4_rightedge+r5_rightedge+r6_rightedge+r7_rightedge+r8_rightedge+r9_rightedge)
    print(f"angular speed {angular_speed_y_rightedge}")

    #Return Linear and Angular speed 
    speed_rightedge.append(linear_speed_x_rightedge)
    speed_rightedge.append(angular_speed_y_rightedge)
    print(f"FRS_LOW: {map_rightedge['frs_low']}    FRS_MEDIUM: {map_rightedge['frs_medium']}    FRS_HIGH: {map_rightedge['frs_high']}") 
    print(speed_rightedge)
    return speed_rightedge



#######################################################################################################################################################################################


# OBSTACLE AVOIDANCE 
def obstacle_avoidance():
    print ("obstacle_avoidance")

    #Declarations for inputs (Front Right Sensors, Back Right Sensors and Front sensors)
    global frnt1_low, frnt1_medium, frnt1_high, frnt2_low, frnt2_medium, frnt2_high, frnt3_low, frnt3_medium, frnt3_high

    #Declarations for inputs (Linear and Angular)
    global linear_slow, linear_medium, linear_fast, angular_right, angular_forward, angular_left

    #min value - FIRING STRENGTHS
    global r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, r20, r21, r22, r23, r24, r25, r26, r27

    #declaring linear_speed and angular_speed
    global linear_speed_x, angular_speed_y
 
    
    #Define regions for FS inputs
    frnt1_low = [0.0, 0.25, 0.75]
    frnt1_medium = [0.25, 0.75, 0.85]
    frnt1_high = [0.75, 0.85, 1]

    #Define regions for FRS inputs
    frnt2_low = [0.0, 0.25, 0.75]
    frnt2_medium = [0.25, 0.75, 0.85]
    frnt2_high = [0.75, 0.85, 1]

    #Define regions for BRS outputs
    frnt3_low = [0.0, 0.25, 0.75]
    frnt3_medium = [0.25, 0.75, 0.85]
    frnt3_high = [0.75, 0.85, 1.0]  # frnt3_high = [0.25, 0.75, 0.85]



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

    # Dictionary to update values of fuzzification
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

    if (((regions_['front1'] + regions_['front2'])) >= frnt2_low[0]) and (((regions_['front1'] + regions_['front2'])) <= frnt2_low[1]):
        map_['frnt2_low'] = 1
        print('frnt2_low1')

    if (((regions_['front1'] + regions_['front2'])) > frnt2_low[1]) and (((regions_['front1'] + regions_['front2'])) <= frnt2_low[2]):
        map_['frnt2_low'] = (frnt2_low[2] - ((regions_['front1'] + regions_['front2']))) / (frnt2_low[2] - frnt2_low[1])
        print('frnt2_low2')

    if (((regions_['front1'] + regions_['front2'])) >= frnt2_medium[0]) and (((regions_['front1'] + regions_['front2'])) <= frnt2_medium[1]):
        map_['frnt2_medium'] = (((regions_['front1'] + regions_['front2'])) - frnt2_medium[0]) / (frnt2_medium[1] - frnt2_medium[0])
        print('frnt2_medium1')

    if (((regions_['front1'] + regions_['front2']))  > frnt2_medium[1]) and (((regions_['front1'] + regions_['front2'])) <= frnt2_medium[2]):
        map_['frnt2_medium'] = (frnt2_medium[2]-((regions_['front1'] + regions_['front2']))) / (frnt2_medium[2] - frnt2_medium[1])
        print('frnt2_medium2')

    if (((regions_['front1'] + regions_['front2'])) >= frnt2_high[0]) and (((regions_['front1'] + regions_['front2']))<= frnt2_high[1]):
        map_['frnt2_high'] = (((regions_['front1'] + regions_['front2']))- frnt2_high[0]) / (frnt2_high[1] - frnt2_high[0])
        print('frnt2_high1')

    if (((regions_['front1'] + regions_['front2'])) > frnt2_high[1]):
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




    # Firing Strengths according to rules 
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


    # DEFUZZIFICATION USING CENTROID MEATHOD

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



#######################################################################################################################################################################################
#combination

def combination():

    global d1_obstacle, d2_rightedge, d1_region_obstacle, d2_region_rightedge, d3_region_goalseek, LMS_re, RMS_re, LMS_oa, RMS_oa,speed_comination, LMS_combination, RMS_combination

    # List to update linear and angular speed
    speed_comination = []
  
    # Dictionary to update fuzzification values
    global map_combination
    map_combination = {
        'M_d1_obstacle': 0,
        'M_d2_rightedge':0,
                                                                                                                                 
    }

    # Assigning values of regions
    d2_region_rightedge = [0.0, 0.3, 0.6]
    d1_region_obstacle = [0.0, 0.5, 0.8]
  
    # Min values of sensor readings
    d1_obstacle = min((regions_['fleft']),(regions_['fright']), ((regions_['front1'] + regions_['front2'])/2) )
    d2_rightedge = min((regions_['fright']),(regions_['right']))


    # FUZZIFICATION
    if (d1_obstacle >= d1_region_obstacle[0]) and (d1_obstacle <= d1_region_obstacle[1] ):
        map_combination['M_d1_obstacle'] = 1
        print(f"membership value d1_1:{map_combination['M_d1_obstacle']}")
    
    if (d1_obstacle > d1_region_obstacle[1]) and (d1_obstacle <= d1_region_obstacle[2]):
        map_combination['M_d1_obstacle'] = ((d1_region_obstacle[2]) - (d1_obstacle)) / ((d1_region_obstacle[2]) - (d1_region_obstacle[1]))
        print(f"membership value d1_2:{map_combination['M_d1_obstacle']}")

    if (d2_rightedge >= d2_region_rightedge[0]) and (d2_rightedge <= d2_region_rightedge[1] ):
        map_combination['M_d2_rightedge'] = 1
        print(f"membership value d2_1:{map_combination['M_d2_rightedge']}")
    
    if (d2_rightedge > d2_region_rightedge[1]) and (d2_rightedge <= d2_region_rightedge[2]):
        map_combination['M_d2_rightedge'] = ((d1_region_obstacle[2]) - (d1_obstacle)) / ((d1_region_obstacle[2]) - (d1_region_obstacle[1]))
        print(f"membership value d2_2:{map_combination['M_d2_rightedge']}")

    if (map_combination['M_d1_obstacle']==0) and (map_combination['M_d2_rightedge']==0):
        map_combination['M_d1_obstacle'] = 1
        map_combination['M_d2_rightedge'] = 0

    # Updating linear speed and angular speed
    LMS_oa = obstacle_avoidance()[0]
    RMS_oa = obstacle_avoidance()[1]
    LMS_re = right_edge()[0]
    RMS_re = right_edge()[1]

    # DEFUZZIFICATION
    LMS_combination = (((map_combination['M_d1_obstacle']) * LMS_oa) + ((map_combination['M_d2_rightedge']) * LMS_re)) / ((map_combination['M_d1_obstacle'])+(map_combination['M_d2_rightedge']))
    RMS_combination = (((map_combination['M_d1_obstacle']) * RMS_oa) + ((map_combination['M_d2_rightedge']) * RMS_re)) / ((map_combination['M_d1_obstacle'])+(map_combination['M_d2_rightedge']))

    speed_comination.append(LMS_combination)
    speed_comination.append(RMS_combination)
    return speed_comination 


#Basic movement method
def movement():
    #print("here")
    global regions_, mynode_, regions
    regions = regions_ 
    
    #create an object of twist class, used to express the linear and angular velocity of the turtlebot 
    msg = Twist()
    
    msg.linear.x = combination()[0]
    msg.angular.z = combination()[1]
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
