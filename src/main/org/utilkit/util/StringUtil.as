package org.utilkit.util
{
	public class StringUtil
	{
		public static function trim(str:String):String
		{
			for(var i:int = 0; str.charCodeAt(i) < 33; i++) { }
			for(var j:int = str.length-1; str.charCodeAt(j) < 33; j--) { }
			
			return str.substring(i, j+1);
		}
	}
}