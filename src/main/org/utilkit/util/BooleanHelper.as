package org.utilkit.util
{
	public final class BooleanHelper
	{
		public static function stringToBoolean(value:String):Boolean
		{
			switch (value)
			{
				case "true":
				case "yes":
				case "yep":
				case "1":
					return true;
				case "false":
				case "no":
				case "nope":
				case "0":
					return false;
				default:
					return new Boolean(value);
			}
		}
	}
}