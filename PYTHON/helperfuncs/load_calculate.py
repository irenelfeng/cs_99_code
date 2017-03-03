# load and calculate dprime and crit 
import scipy.io as sio 
import numpy as np 
import dprime

# get d_prime and crit for every output in matrix m
def calculate(m):
    total = m.sum().sum()
    d_prime = np.zeros((m.shape[1],1))
    crit = np.zeros((m.shape[1],1))
    for e in range(m.shape[1]):
        hits = m[e, e]
        misses = sum(m[e, :]) - hits
        fas = sum(m[:, e]) - hits
        crs = total - hits - misses - fas # just the leftovers for the emot
        out = dprime.dPrime(hits, misses, fas, crs)
        d_prime[e] = out['d']
        crit[e] = out['c']
    return d_prime, crit

TD_Matrices = sio.loadmat('../TD_Matrices.mat')['TD_Matrices']
Total_TD = sio.loadmat('../Total_TD.mat')['Total_TD']
TD_Matrices = np.dstack((TD_Matrices, Total_TD))
d_prime = np.zeros((TD_Matrices.shape[1], TD_Matrices.shape[2])) # emotions x paper
crit = np.zeros((TD_Matrices.shape[1],TD_Matrices.shape[2])) # emotions x paper
for i in range(TD_Matrices.shape[2]):
    m = TD_Matrices[:,:,i]
    total = m.sum().sum()
    for e in range(m.shape[1]):
        hits = m[e, e]
        misses = sum(m[e, :]) - hits
        fas = sum(m[:, e]) - hits # get the column sum 
        crs = total - hits - misses - fas # just everything else for the emot
        out = dprime.dPrime(hits, misses, fas, crs)
        d_prime[e,i] = out['d']
        crit[e,i] = out['c']

print d_prime
print crit
# do the same for ASD, too lazy right now 
ASD_Matrices = sio.loadmat('../ASD_Matrices.mat')['ASD_Matrices']
Total_ASD = sio.loadmat('../Total_ASD.mat')['Total_ASD']
ASD_Matrices = np.dstack((ASD_Matrices, Total_ASD))
for i in range(ASD_Matrices.shape[2]):
    m = ASD_Matrices[:,:,i]
    total = m.sum().sum()
    for e in range(m.shape[1]):
        hits = m[e, e]
        misses = sum(m[e, :]) - hits
        fas = sum(m[:, e]) - hits # get the column sum 
        crs = total - hits - misses - fas # just everything else for the emot
        out = dprime.dPrime(hits, misses, fas, crs)
        d_prime[e,i] = out['d']
        crit[e,i] = out['c']

print d_prime
print crit

# now do it for actual models? 
m = sio.loadmat('../molla_pconf_whole_32299_35888_120.mat')['conf_mat']
calculate(m)
m = sio.loadmat('../.mat')['conf_mat']







