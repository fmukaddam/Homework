import numpy as np
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, jsonify
import datetime as dt
import pandas as pd

#Create Engine
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

#Reflect Database
Base = automap_base()
Base.prepare(engine, reflect=True)

#Save table references
Measurement = Base.classes.measurement
Station = Base.classes.station

#Create Session
session = Session(engine)

first_date = session.query(Measurement.date).order_by((Measurement.date)).limit(1).all()
print(first_date[0][0])
last_date = session.query(Measurement.date).order_by((Measurement.date).desc()).limit(1).all()
print(last_date[0][0])
last_year = (dt.datetime.strptime(last_date[0][0], '%Y-%m-%d') - dt.timedelta(days=365)).date()
print(last_year)

#Setup Flask
app = Flask(__name__)

#Set Flask Routes
@app.route("/")
def welcome():
    return (
        "Welcome to the Hawaii weather API !<br/>"
        f"These are the available routes:<br/>"
        f"/api/v1.0/precipitation<br/> - Returns a JSON representation of percipitation data<br/>"
        f"/api/v1.0/stations<br/> - Returns a JSON list of the weather stations<br/>"
        f"/api/v1.0/tobs<br/> - Returns a JSON list of the Temperature Observations (tobs) for each station<br/>"
        f"/api/v1.0/yourstartdate(yyyy-mm-dd)<br/> - Returns a JSON list of the minimum temperature, the average temperature, and the max temperature for the dates from the given start date in yyyy-mm-dd format<br/>"
        f"/api/v1.0/start_date(yyyy-mm-dd)/end_date(yyyy-mm-dd)<br/> - Returns a JSON list of the minimum temperature, the average temperature, and the max temperature for the dates between the given start date and end date<br/>")


@app.route("/api/v1.0/precipitation")
def precipitation():
    print("API precipitation request received")
    
    results = session.query(Measurement.date, Measurement.prcp).filter(Measurement.date > last_year).order_by(Measurement.date).all()
    precipitation_data = []
    for prcp_total in results:
        row= {}
        row["date"] = prcp_total.date
        row["prcp"] = prcp_total.prcp
        precipitation_data.append(row)
    return jsonify(precipitation_data)

@app.route("/api/v1.0/stations")
def station():
    print("Status of Station : OK")
    #Creating a query to get the stations.
    station_query = session.query(Station.name, Station.station)
    station = pd.read_sql(station_query.statement, station_query.session.bind)
    #Return a JSON list of stations from the dataset.
    return jsonify(station.to_dict())

@app.route("/api/v1.0/tobs")
def tobs():
	print("Status of Tobs :OK")
	#query for the dates and temperature observations from a year from the last data point
	tobs_results = session.query(Measurement.date, Measurement.tobs).filter(Measurement.date >= last_year).order_by(Measurement.date).all()
	# Create a list of dicts with `date` and `tobs` as the keys and values
	tobs_total = []
	for result in tobs_results:
		row = {}
		row["date"] = result[0]
		row["tobs"] = result[1]
		tobs_total.append(row)
	#Return a JSON list of Temperature Observations (tobs) for the previous year.
	return jsonify(tobs_total)

@app.route("/api/v1.0/<start>")
def start_date(start):
	print("start_date status:OK")
	start_date = dt.datetime.strptime(start, '%Y-%m-%d').date()
	last_date_final = (dt.datetime.strptime(last_date[0][0], '%Y-%m-%d')).date() 
	first_date_final = (dt.datetime.strptime(first_date[0][0], '%Y-%m-%d')).date() 
	if start_date > last_date_final or start_date < first_date_final:
		return(f"Select date range between {first_date[0][0]} and {last_date[0][0]}")
	else:
		final_calc = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= start_date).all()
		start_date_data = list(np.ravel(final_calc))
		return jsonify(start_date_data)

@app.route("/api/v1.0/<start>/<end>")
def end_date(start,end):
	print("start and end status:OK")
	start_date = dt.datetime.strptime(start, '%Y-%m-%d').date()
	end_date = dt.datetime.strptime(end, '%Y-%m-%d').date()
	last_date_final = (dt.datetime.strptime(last_date[0][0], '%Y-%m-%d')).date() 
	first_date_final = (dt.datetime.strptime(first_date[0][0], '%Y-%m-%d')).date()
	if start_date > last_date_final or start_date < first_date_final or end_date > last_date_final or\
	 					end_date < first_date_final:
		return(f"Select date range between {first_date[0][0]} and {last_date[0][0]}")
	else:
		calc_temp = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs),func.max(Measurement.tobs)).filter(Measurement.date >= start_date).filter(Measurement.date <= end_date).all()
		start_end_data = list(np.ravel(calc_temp))
		return jsonify(start_end_data)

if __name__ == "__main__":
    app.run(debug=True)