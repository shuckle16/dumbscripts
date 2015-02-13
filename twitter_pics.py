from BeautifulSoup import BeautifulSoup
import urllib2
url = "https://www.twitter.com/TWITTERHANDLE/media"
page = urllib2.urlopen(url)
soup = BeautifulSoup(page.read())
pics = soup.findAll('img',{'class':'TwitterPhoto-mediaSource'})
for pic in pics:
	print pic["src"]
