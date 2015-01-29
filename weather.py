from BeautifulSoup import BeautifulSoup
import urllib2
url="http://forecast.weather.gov/MapClick.php?lat=35.963699341452525&lon=-83.9193374991255&site=all&smap=1"
page=urllib2.urlopen(url)
soup = BeautifulSoup(page.read())
description=soup.findAll('p',{'class':'myforecast-current'})
temperature=soup.findAll('p',{'class':'myforecast-current-lrg'})

print description[0].text
print temperature[0].text[:2], "F"
