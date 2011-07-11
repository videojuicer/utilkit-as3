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
		
		public static function isNumeric(value:Object):Boolean
		{
			return !isNaN(parseInt(value.toString()));
		}
		
		public static function toHumanReadableString(value:Number):String
		{
			var str:String = Math.round(value).toString();
			var result:String = '';
			
			while (str.length > 3)
			{
				var chunk:String = str.substr(-3);
				
				str = str.substr(0, str.length - 3);
				
				result = ',' + chunk + result
			}
			
			if (str.length > 0)
			{
				result = str + result
			}
			
			return result
		}
	}
}