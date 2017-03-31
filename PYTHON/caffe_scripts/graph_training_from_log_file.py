import matplotlib.pyplot as plt
import sys 
import re

accuracies = [] 
log_file = sys.argv[1]
# def group_by_heading( some_source ):
#     buffer= []
#     counter=0
#     flag=0
#     for line in some_source:
#         if "Testing net" in line:
#             if buffer: yield buffer
#             buffer= [ line ]
#         else:
#             if counter < 1:
#                 counter = 1 # just gets the second line 
#                 continue
#             m = re.search('(?<=-1 = ).*', line) # gets the accuracy of the group 
#             print line
#             buffer.append( m.group(0) )
#             counter = 0
#     yield buffer

iters = []
accuracies = []
with open( log_file, "r" ) as source:
    test_iter = False
    counter = 0
    for line in source: 
        # a test iter 
        if "Testing net" in line:
            test_iter = True
            m = re.search('(?<=Iteration )[0-9]+', line)
            iters.append( m.group(0) )
        else:
            if test_iter != True: # this means we're getting the next line
                continue 
            if counter == 0:
                counter = 1
                continue
            # now this is the right line :) 
            m = re.search('(?<=-1 = ).*', line) # gets the accuracy of the group
            accuracies.append( m.group(0) )
            # reset variables 
            counter = 0
            test_iter = False 
# graph the accuracy over iterations please, for testing error and training error
plt.plot([1, 2, 3, 4], [1, 4 ,6, 2])
# plt.plot(iters,accuracies)
plt.ylabel('Error Rate')
# plt.show()