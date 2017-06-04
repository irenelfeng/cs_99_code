import matplotlib.pyplot as plt
import sys 
import re
import math 
accuracies = [] 
log_file = sys.argv[1]

train_iters = []
train_acc = []
iters = []
accuracies = []
with open( log_file, "r" ) as source:
    test_iter = False
    counter = 0
    for line in source: 
        m = re.search('Iteration ([0-9]+), loss = (.*)',line)
        if m and int(m.group(1)) % 4000 == 0: 
            train_iters.append(int(m.group(1)))
            train_acc.append(m.group(2))

        # a test iter 
        elif "Testing net" in line:
            test_iter = True
            m = re.search('(?<=Iteration )[0-9]+', line)
            iters.append( int(m.group(0)) )
        else:
            if test_iter != True: # this means we're getting the next line
                continue
            if "blocking_queue.cpp" in line: 
                print "skipped"
                continue 
                # skip anything that has anything with threads
            if counter == 0:
                counter = 1
                continue
                # lol something stupid 
            # now this is the right line :) 
            m = re.search('(?<=-1 = ).*', line) # gets the accuracy of the group
            accuracies.append( m.group(0) )
            # reset variables 
            counter = 0
            test_iter = False 

iters = map(lambda x: x/1000, iters)
train_iters = map(lambda x: x/1000, train_iters)

# graph the accuracy over iterations please, for testing error and training error
if len(iters) > 1000: # too cluttered so 
    # get in the 100s order 
    order = math.floor((math.log10(len(iters))))
    iters = [c for i,c in enumerate(iters) if i % (4*10**(order-2)) == 0]
    accuracies = [c for i,c in enumerate(accuracies) if i % (4*10**(order-2)) == 0]

train_acc = map(lambda x: float(x), train_acc)
max_loss = max(train_acc)
train_acc = map(lambda x: (max_loss - x)/max_loss, train_acc)


plt.plot(iters, accuracies, 'b', train_iters, train_acc, 'r') # Testing error. also do training. 
plt.ylabel('Accuracy Rate')
plt.xlabel('Iterations (*1k)')
plt.savefig(log_file+'.jpg')
