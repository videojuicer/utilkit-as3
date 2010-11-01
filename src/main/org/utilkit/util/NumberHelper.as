package org.utilkit.util
{
	public class NumberHelper
	{
		public static function zeroPad(number:int, minWidth:int):String
		{
			var ret:String = "" + number.toString();
			
			while(ret.length < minWidth)
			{
				ret = "0" + ret;
			}
			
			return ret;
		}
	}
}