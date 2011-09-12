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
 * The Original Code is the SMILKit library / StyleKit library / UtilKit library.
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
	}
}
