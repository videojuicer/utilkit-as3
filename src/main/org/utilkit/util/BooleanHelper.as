package org.utilkit.util
{
	public final class BooleanHelper
	{
		public static function stringToBoolean(value:String):Boolean
		{
			var result:Boolean = false;
			
			switch (value)
			{
				case "true":
				case "yes":
				case "yep":
				case "1":
				case 1:
					result = true;
					break;
				case "false":
				case "no":
				case "nope":
				case "0":
				case 0:
					result = false;
					break;
				default:
					result = new Boolean(value);
					break;
			}
			
			return result;
		}
	}
}