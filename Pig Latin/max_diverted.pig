A = load 's3://flightdataanalysis/Input' using PigStorage(',') as
(YEAR:int,	MONTH:int,	DAY_OF_MONTH:int,	DAY_OF_WEEK:int,	FL_DATE:chararray,	UNIQUE_CARRIER:chararray,	TAIL_NUM:chararray,	FL_NUM:int,	ORIGIN_AIRPORT_ID:int,	ORIGIN:chararray,	ORIGIN_STATE_ABR:chararray,	DEST_AIRPORT_ID:int,	DEST:chararray,	DEST_STATE_ABR:chararray,	CRS_DEP_TIME:int,	DEP_TIME:int,	DEP_DELAY:int,	DEP_DELAY_NEW:int,	DEP_DEL15:int,	DEP_DELAY_GROUP:int,	TAXI_OUT:int,	WHEELS_OFF:int,	WHEELS_ON:int,	TAXI_IN:int,	CRS_ARR_TIME:int,	ARR_TIME:int,	ARR_DELAY:int,	ARR_DELAY_NEW:int,	ARR_DEL15:int,	ARR_DELAY_GROUP:int,	CANCELLED:int,	CANCELLATION_CODE:chararray,	DIVERTED:int,	CRS_ELAPSED_TIME:int,	ACTUAL_ELAPSED_TIME:int,	AIR_TIME:int,	FLIGHTS:int,	DISTANCE:int,	DISTANCE_GROUP:int,	CARRIER_DELAY:int,	WEATHER_DELAY:int,	NAS_DELAY:int,	SECURITY_DELAY:int,	LATE_AIRCRAFT_DELAY:int);
diverted_info = foreach A generate YEAR,ORIGIN,DEST,DIVERTED;
diverted_true = FILTER diverted_info BY (ORIGIN is not null) AND (DEST is not null) AND (DIVERTED == 1);
g_d_true = GROUP diverted_true by (ORIGIN,DEST);
cnt_gdtrue = FOREACH g_d_true generate group, COUNT(diverted_true.DIVERTED) as cnt;
ord_cnt_gdtrue = order cnt_gdtrue by cnt desc;
most_diverted = limit ord_cnt_gdtrue 10;
store most_diverted into 's3://flightdataanalysis/most_diverted';