A = load 's3://flightdataanalysis/Input' using PigStorage(',') as
(YEAR:int,	MONTH:int,	DAY_OF_MONTH:int,	DAY_OF_WEEK:int,	FL_DATE:chararray,	UNIQUE_CARRIER:chararray,	TAIL_NUM:chararray,	FL_NUM:int,	ORIGIN_AIRPORT_ID:int,	ORIGIN:chararray,	ORIGIN_STATE_ABR:chararray,	DEST_AIRPORT_ID:int,	DEST:chararray,	DEST_STATE_ABR:chararray,	CRS_DEP_TIME:int,	DEP_TIME:int,	DEP_DELAY:int,	DEP_DELAY_NEW:int,	DEP_DEL15:int,	DEP_DELAY_GROUP:int,	TAXI_OUT:int,	WHEELS_OFF:int,	WHEELS_ON:int,	TAXI_IN:int,	CRS_ARR_TIME:int,	ARR_TIME:int,	ARR_DELAY:int,	ARR_DELAY_NEW:int,	ARR_DEL15:int,	ARR_DELAY_GROUP:int,	CANCELLED:int,	CANCELLATION_CODE:chararray,	DIVERTED:int,	CRS_ELAPSED_TIME:int,	ACTUAL_ELAPSED_TIME:int,	AIR_TIME:int,	FLIGHTS:int,	DISTANCE:int,	DISTANCE_GROUP:int,	CARRIER_DELAY:int,	WEATHER_DELAY:int,	NAS_DELAY:int,	SECURITY_DELAY:int,	LATE_AIRCRAFT_DELAY:int);
c_cancel = foreach A generate YEAR, MONTH, FL_NUM, CANCELLED, CANCELLATION_CODE;
filter_cancelled = filter c_cancel by CANCELLED == 1 AND CANCELLATION_CODE =='B';
g_filter_cancelled = group filter_cancelled by MONTH;
cnt_cancelled = foreach g_filter_cancelled generate group, COUNT(filter_cancelled.CANCELLED);
max_cancelled = limit cnt_cancelled 12;
store max_cancelled into 's3://flightdataanalysis/max_cancelled_weather';