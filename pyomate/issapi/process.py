## api to check when ISS is going to be overhead
import requests
import datetime

# These are the lattitude and longitude to locate ( default is dorking )
parameters = {"n": 6}

# Get lat and long from postcode
def address(pc):
    q ={"q":pc}
    r = requests.get("http://api.postcodes.io/postcodes?", params=q)
    mer = r.json()
    for results in (mer["result"]):
        lat = (results["latitude"])
        lon = (results["longitude"])
        dic = {"lat": lat, "lon": lon}
                
    return dic


# make a get request with the parameters
def getiss(parameter_list):
    response = requests.get("http://api.open-notify.org/iss-pass.json", params=parameters)
    data = response.json()
    return data


# print out the contents of the response
def results():
    times = getiss(parameters)
    for event in(times["response"]):
        time = event['risetime']
        print(datetime.datetime.fromtimestamp(time).strftime('%Y-%m-%d %H:%M:%S'))

postcode = input("Please enter your postcode: ")
parameters.update(address(postcode))
results()