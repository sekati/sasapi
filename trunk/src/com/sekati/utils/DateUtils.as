/**
 * com.sekati.utils.DateUtils
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
  
 /**
  * Static function for handling dates from db and converting them into readable strings
  * 
  * {@code Usage:
  * var d = DateUtils.dateFromDB("2006-06-01 12:10:45");
  * trace(DateUtils.days[d.getDay()] + ", " + DateUtils.months[d.getMonth()] + " " + d.getDate() + ", " + (d.getHours()%12) + ":" + DateUtils.padTime(d.getMinutes()) + ((d.getHours() > 12) ? "pm" :"am"));
  * }
  */
class com.sekati.utils.DateUtils {
	/**
	 * gets 0 indexed array of months for use with Date.getMonth()
	 */
	public static function get months ():Array {
		return new Array ("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
	}
	/**
	 * gets 0 indexed array of days for use with Date.getDay()
	 */
	public static function get days ():Array {
		return new Array ("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
	}
	/**
	 * pads hours,minutes or seconds with a leading 0, 12:01 doesn't end up 12:1
	 */
	public static function padTime (inn):String {
		return (String (inn).length < 2) ? ("0" + inn) : inn;
	}
	/**
	 * converts a db formatted date string into a Flash Date object
	 * @param dbDate (String) date in YYYY-MM-DD HH:MM:SS format
	 * @return Date
	 */
	public static function dateFromDB (dbdate):Date {
		var tmp = dbdate.split (" ");
		var dates = tmp[0].split ("-");
		var hours = tmp[1].split (":");
		var d = new Date (dates[0], dates[1] - 1, dates[2], hours[0], hours[1], hours[2]);
		return d;
	}
	/**
	 * takes 24hr hours and converts to 12 hour with am/pm
	 * @param hour24 (Number)
	 * @return Object
	 */
	public static function getHoursAmPm (hour24:Number):Object {
		var returnObj:Object = new Object ();
		returnObj.ampm = (hour24 < 12) ? "am" : "pm";
		var hour12:Number = hour24 % 12;
		if (hour12 == 0) {
			hour12 = 12;
		}
		returnObj.hours = hour12;
		return returnObj;
	}
	
	private function DateUtils(){}
	//
}
// eof