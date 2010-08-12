package org.utilkit.util
{
	public class StringUtil
	{
		public static function trim(str:String):String
		{
			return StringUtil.ltrim(StringUtil.rtrim(str));
		}
		
		public static function ltrim(str:String):String
		{
			for (var i:Number = 0; i < str.length; i++)
			{
				if (str.charCodeAt(i) > 32)
				{
					return str.substring(i);
				}
			}
			
			return "";
		}
		
		public static function rtrim(str:String):String
		{
			for (var i:Number = str.length; i > 0; i--)
			{
				if (str.charCodeAt(i - 1) > 32)
				{
					return str.substring(0, i);
				}
			}
			
			return "";
		}
		
		public static function stringsAreEqual(str1:String, str2:String, caseSensitive:Boolean):Boolean
		{
			if (caseSensitive)
			{
				return (str1 == str2);
			}
			else
			{
				return (str1.toLowerCase() == str2.toLowerCase());
			}
		}
	}
}