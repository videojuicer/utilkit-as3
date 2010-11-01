package org.utilkit.util
{
	public class TimeHelper
	{
		public static function millisecondsToWallclock(milliseconds:Number):String
		{
			var result:String = "";
			
			var seconds:int = Math.floor(milliseconds / 1000);
			var minutes:int = Math.floor(seconds / 60);
			seconds = seconds % 60;
			
			var hours:int = Math.floor(minutes / 60);
			minutes = minutes % 60;
			
			if (hours != 0)
			{
				result = NumberHelper.zeroPad(hours, 2) + ":";
			}
			
			result += NumberHelper.zeroPad(minutes, 2)+":";
			result += NumberHelper.zeroPad(seconds, 2);
			
			return result;
		}
	}
}