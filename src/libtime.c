/*
 *				libtime.c
 *
 * Random time functions.
 */

/*
 *				history
 *
 * 93Jan17 HAW	Created from misc.c.
 */

#include "ctdl.h"
#include "time.h"

/*
 *				contents
 *
 *	civTime()		MilTime to CivTime
 */

/*
 * civTime()
 *
 * Military time to Civilian time.
 */
void civTime(int *hours, char **which)
{
    if (*hours >= 12)
	*which = "pm";
    else
	*which = "am";
    if (*hours >= 13)
	*hours -= 12;
    if (*hours == 0)
	*hours = 12;
}

/*
 * Current_Time()
 *
 * This function will get the current time, format cutely.
 */
char *Current_Time()
{
    char  *ml, *month;
    int   year, day, h, m;
    static char Time[13];

    getCdate(&year, &month, &day, &h, &m);
    civTime(&h, &ml);
    sprintf(Time, "%d:%02d %s", h, m, ml);
    return Time;
}

char  *monthTab[13] = {"", "Jan", "Feb", "Mar",
			   "Apr", "May", "Jun",
			   "Jul", "Aug", "Sep",
			   "Oct", "Nov", "Dec" };

// This will return a human string representing that date.
char* AbsToReadable(unsigned long lastdate){
    struct tm* data;
    char* m;
    static char buffer[40];

    /* 0l represents never in our scheme */
    if(lastdate==0l) return "Never";

    data=localtime((time_t*)&lastdate);
    civTime(&data->tm_hour, &m);

    sprintf(buffer, "%d%s%02d @ %d:%02d %s",
			data->tm_year, monthTab[data->tm_mon + 1],
			data->tm_mday, data->tm_hour, data->tm_min, m);
    return buffer;
}

// Format a Citadel standard date string
static void CitaDate(char* str,int y,int m,int d){
    sprintf(str,"%d%s%02d",y,monthTab[m],d);
}

// This function forms the current date.
char *formDate(){
    int y,m,d,h,min,s,ms;
    static char dateLine[10];
    getRawDate(&y,&m,&d,&h,&min,&s,&ms);
    CitaDate(dateLine,y,m,d);
    return dateLine;
}

// This retrieves system date and returns in the parameters.
void getCdate(int *year, char **month, int *day, int *hours, int *minutes)
{
    int mon, seconds, milli;

    getRawDate(year, &mon, day, hours, minutes, &seconds, &milli);
    /* year used to be converted to 2 digits here, not doing that anymore */
    *month = monthTab[mon];
}

// This function converts a DOS-formatted date to a formatted string.
void DosToNormal(char* DateStr,UNS_16 DosDate){
	int month=(DosDate>>5)&0xf;
	if(month>12||month<1)
		strcpy(DateStr,"No Date");
	else
		CitaDate(DateStr,
			((DosDate>>9)&0x7f)+1980,
			month,
			DosDate&0x1f);
}