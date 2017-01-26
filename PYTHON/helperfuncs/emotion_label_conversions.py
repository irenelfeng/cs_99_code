# emotion label dictionaries

def invert_dic(dic):
	inv_map = {v: k for k, v in dic.iteritems()}
	return inv_map

# Alphabetical but Neutral is at the end. 
def fer_dic(): 
	return {
		0:'Anger', 
		1:'Disgust', 
		2:'Fear', 
		3:'Happiness', 
		4:'Sad', 
		5:'Surprise', 
		6:'Neutral' 
	}

# Alphabetical but Neutral first
def ck_dic():
	return {
		0:'Neutral', 
		1:'Anger',
		# 2:'Contempt',
		3:'Disgust', 
		4:'Fear', 
		5:'Happiness', 
		6:'Sad', 
		7:'Surprise'
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

def emot_conversion(target, source):
	return { k: invert_dic(target)[v] for k,v in source.iteritems() }

