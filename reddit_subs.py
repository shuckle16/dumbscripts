import urllib2
import json
import matplotlib.pyplot as plt

mysubs = ["programming","python"]
myDB = {}

def gather(mysubs):
    for sub in mysubs:
        myurl = urllib2.urlopen("http://www.reddit.com/r/{0}.json?limit=200".format(sub))
        myjson =  json.loads(myurl.read())
        myDB[sub] = []
        for i in range(25):
            myDB[sub].append(myjson["data"]["children"][i]["data"]["ups"])
        
def plottin(sub):
    plt.hist(myDB[sub], bins=20)


