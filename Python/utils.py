import time
import csv
import unicodedata
from datetime import datetime, timedelta
import urllib.request
import json

def hour_rounder(t):
    # Rounds to nearest hour by adding a timedelta hour if minute >= 30
    return (t.replace(second=0, microsecond=0, minute=0, hour=t.hour)
               +timedelta(hours=t.minute//30))

def date_for_url(date):
    datetime_object = datetime.strptime(date, '%Y-%m-%d %H:%M:%S')
    new_date = str(datetime_object).split(' ')[0].replace('-','/',2)
    new_date = new_date.split('/')[2]+'/'+new_date.split('/')[1]+'/'+new_date.split('/')[0]
    return new_date

def get_correct_period(date):
    datetime_object = datetime.strptime(date, '%Y-%m-%d %H:%M:%S')
    Hour = hour_rounder(datetime_object)
    return int(Hour.hour)

def simplify(text):
    try:
        text = unicode(text, 'utf-8')
    except NameError:
        pass
    text = unicodedata.normalize('NFD', text).encode('ascii', 'ignore').decode("utf-8")
    return str(text)

def create_new_ids(id_list,elements_without_ids):
    new_ids = []
    int_id_list = list(map(int, id_list))
    all_ids = range(len(id_list)+len(elements_without_ids)+max(int_id_list))
    potential_ids = list(set(all_ids).difference(set(int_id_list)))
    if len(potential_ids) > len(elements_without_ids):
        for i in range(len(elements_without_ids)):
            new_ids.append(str(potential_ids[i]))
    else:
        print('theres a problem')
    return new_ids

def get_stadium_locations(stadiums_path):
    stadiums = {}
    row_count = 0 
    with open(stadiums_path,  encoding='UTF-8') as csv_file:
        csv_reader = csv.reader(csv_file,delimiter=',')
        for row in csv_reader:
            if row_count == 0:
                row_count += 1
            else:
                if row[0][-1] == ' ':
                    row[0] = row[0][:-1]
                stadiums[simplify(row[0])]=(str(row[1]),str(row[2]))
    return stadiums


def add_one_to_date(date):
    datetime_object = datetime.strptime(date, '%Y-%m-%d %H:%M:%S')
    datetime_object = datetime_object+timedelta(days=1)
    return str(datetime_object)


def get_team_ids(team_id_path):
    team_ids = {}
    row_count = 0
    with open (team_id_path, encoding='UTF-8') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            if row_count == 0:
                row_count += 1
            else:
                team_ids[row[0]]=simplify(row[1])
    return team_ids

def get_match_dates(matches_path, team_ids):
    game_ids = {}
    row_count = 0
    with open(matches_path) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        for row in csv_reader:
            if row_count == 0:
                row_count += 1
            else:
                game_ids[row[0]]={'date':row[3],'location':team_ids[row[4]]}
    return game_ids


def api_request(match,stadiums,client_id,secret_key):
    import json
    LatLong = stadiums[match['location']]
    date = match['date']

    date0 = date_for_url(date)
    date1 = add_one_to_date(date)
    date1= date_for_url(date1)
    
    #remember there's a different secret key and shit for each account, maybe make this an arg ?
    url=f'https://api.aerisapi.com/conditions/{str(LatLong[0])},{str(LatLong[1])}?format=json&from={date0}&to={date1}&plimit=24&filter=1hr&fields=periods.tempC,periods.dewpointC,periods.humidity,periods.windSpeedKPH,periods.weather,periods.feelslikeC&client_id={client_id}&client_secret={secret_key}'
    
    request = urllib.request.urlopen(url)
    response = request.read()
    json = json.loads(response)
    if json['success']:
        request.close()
        return json
    else:
	    print("An error occurred: %s" % (json['error']['description']))
        #request.close()


def get_weather(json,date):
    try:
        weather = json['response'][0]['periods'][get_correct_period(date)]
    except IndexError:
        print(json)
        weather = {'message':'Error'}
    return weather

