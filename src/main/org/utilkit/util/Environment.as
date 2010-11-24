package org.utilkit.util
{
	import flash.external.ExternalInterface;

	public class Environment
	{
		public static function get embeddedURL():String
		{
			var location:String = Environment.callExternalMethod("document.location.toString") as String;
			
			return location;
		}
		
		public static function get embeddedHostname():String
		{
			var hostname:String = Environment.callExternalMethod("document.location.hostname.toString") as String;
			
			if (hostname == null || hostname == "")
			{
				if (Environment.embeddedURL.indexOf("file://") != -1)
				{
					hostname = "localhost";
				}
			}
			
			return hostname;
		}
		
		public static function get userAgent():String
		{
			var agent:String = Environment.callExternalMethod("navigator.userAgent.toString") as String;
			
			if (agent == null)
			{
				agent = "unknown";
			}
			
			return agent;
		}
		
		public static function callExternalMethod(method:String):*
		{
			var result:* = null;
			
			if (ExternalInterface.available)
			{
				try
				{
					result = ExternalInterface.call(method);
				}
				catch (e:Error)
				{
					
				}
				catch (e:SecurityError)
				{
					
				}
			}
			
			return result;
		}
	}
}