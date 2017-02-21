from scipy.stats import norm 
import math 
def dPrime(hits, misses, fas, crs):
    Z = norm.ppf
    # Floors an ceilings are replaced by half hits and half FA's
    halfHit = 0.5/(hits+misses)
    halfFa = 0.5/(fas+crs)
 
    # Calculate hitrate and avoid d' infinity
    hitRate = hits/(hits+misses)
    if hitRate == 1: hitRate = 1-halfHit
    if hitRate == 0: hitRate = halfHit
 
    # Calculate false alarm rate and avoid d' infinity
    faRate = fas/(fas+crs)
    if faRate == 1: faRate = 1-halfFa
    if faRate == 0: faRate = halfFa
 
    # Return d', beta, c and Ad'
    out = {}
    out['sens'] = hits/(fas + hit)
    out['spec'] = crs/(miss + crs)
    out['d'] = Z(hitRate) - Z(faRate) # want a high d', this is just correct - bias
    out['beta'] = math.exp(Z(faRate)**2 - Z(hitRate)**2)/2
    out['c'] = (Z(hitRate) + Z(faRate))/2 # bias - high 
    out['Ad'] = norm.cdf(out['d']/math.sqrt(2))
    return out