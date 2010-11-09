package org.utilkit.util
{
	public class UrlUtil
	{
		public static function addCacheBlocking(url:String):String
		{
			var join:String = "&";
			
			if (url.indexOf("?") == -1)
			{
				join = "?";
			}
			
			return url + join + Math.random().toString().substr(2, 8) + "=1";
		}
	}
}