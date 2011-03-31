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
			return Math.floor(millisecondsToMinutes(milliseconds) / 60);
		}
		
		public static function millisecondsToMinutes(milliseconds:Number):int
		{
			return Math.floor(millisecondsToSeconds(milliseconds) / 60);
		}
		
		public static function millisecondsToSeconds(milliseconds:Number):int
		{
			return Math.floor(milliseconds / 1000);
		}
	}
}