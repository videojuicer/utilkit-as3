package org.utilkit
{
	import org.utilkit.logger.ApplicationLog;
	
	public class UtilKit
	{
		private static var __applicationLog:ApplicationLog = new ApplicationLog("utilkit-as3");
		
		public static function get logger():ApplicationLog
		{
			return UtilKit.__applicationLog;
		}
		
		public static function get version():String
		{
			return "0.3.2";
		}
	}
}