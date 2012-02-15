/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 * 
 * The Original Code is the UtilKit library.
 * 
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 * 
 * ***** END LICENSE BLOCK ******/
package org.utilkit.util
{
	public class TimeHelper
	{
		public static function millisecondsToWallclock(milliseconds:Number):String
		{
			var result:Array = [];
			
			var seconds:int = TimeHelper.millisecondsToSeconds(milliseconds);
			var minutes:int = TimeHelper.millisecondsToMinutes(milliseconds);
			var hours:int = TimeHelper.millisecondsToHours(milliseconds);
			
			seconds = seconds % 60;
			minutes = minutes % 60;
			
			if (hours != 0)
			{
				result.push(NumberHelper.zeroPad(hours, 2));
			}
			
			result.push(NumberHelper.zeroPad(minutes, 2));
			
			if(hours == 0)
			{
				result.push(NumberHelper.zeroPad(seconds, 2));
			}
			
			
			return result.join(":");
		}
		
		public static function millisecondsToHours(milliseconds:Number):int
		{
			return int(millisecondsToMinutes(milliseconds) / 60);
		}
		
		public static function millisecondsToMinutes(milliseconds:Number):int
		{
			return int(millisecondsToSeconds(milliseconds) / 60);
		}
		
		public static function millisecondsToSeconds(milliseconds:Number):int
		{
			return int(milliseconds / 1000);
		}
		
		public static function smilTimeToMilliseconds(timeString:String):int
		{
			var milliseconds:int = 0;
			
			if (timeString == null || timeString == "")
			{
				milliseconds = -100;
			}
			// parse clock values
			else if (timeString.indexOf(":") != -1)
			{
				var split:Array = timeString.split(":");
				
				var hours:uint = 0;
				var minutes:uint = 0;
				var seconds:uint = 0;
				
				// half clock
				if (split.length < 3)
				{
					minutes = uint(split[0]);
					seconds = uint(split[1]);
				}
					// full wall clock
				else
				{
					hours = uint(split[0]);
					minutes = uint(split[1]);
					seconds = uint(split[2]);
				}
				
				milliseconds = ((hours * 60 * 60 * 1000) + (minutes * 60 * 1000) + (seconds * 1000));
			}
			else
			{
				// hours
				if (timeString.indexOf("h") != -1)
				{
					milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("h"))) * 60 * 60 * 1000; 
				}
				// minutes
				else if (timeString.indexOf("min") != -1)
				{
					milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("min"))) * 60 * 1000; 
				}
				// milliseconds value
				else if (timeString.indexOf("ms") != -1)
				{
					milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("ms")));
				}				
				// seconds
				else if (timeString.indexOf("s") != -1)
				{
					milliseconds = parseFloat(timeString.substring(0, timeString.indexOf("s"))) * 1000; 
				}
				// assume the time is declared in seconds
				else
				{
					milliseconds = parseFloat(timeString) * 1000;
				}
			}
			
			return milliseconds;
		}
	}
}
