# emotion label dictionaries

def invert_dic(dic):
	inv_map = {v: k for k, v in dic.iteritems()}
	return inv_map

# Alphabetical but Neutral is at the end. 
def fer_dic(): 
	return {
		0:'Anger', # hand checked this!
		1:'Disgust', 
		2:'Fear', # hand checked this!
		3:'Happiness', # hand checked this!
		4:'Sad', # this is 5?
		5:'Surprise', # this is 6? 
		6:'Neutral' # need to check this one w/: pretty sure this is 4 in Mollahosseini
	}

# Alphabetical
def molla_dic(): 
	return {
		0:'Anger', 
		1:'Disgust', 
		2:'Fear', 
		3:'Happiness',
		4:'Neutral', 
		5:'Sad',
		6:'Surprise' 
	}

def fer_to_molla():
	fer = fer_dic()
	to_molla = invert_dic(molla_dic())
	fer_to_molla = { k: to_molla[v] for k,v in fer.iteritems() }
	return fer_to_molla
