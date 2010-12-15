package org.utilkit.util
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.System;

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
				var embeddedURL:String = Environment.embeddedURL;
				
				if (embeddedURL != null && embeddedURL.indexOf("file://") != -1)
				{
					hostname = "localhost";
				}
			}
			
			if (hostname == null)
			{
				hostname = "unknown";
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
		
		public static function openWindow(request:URLRequest, target:String = "_blank"):void
		{
			navigateToURL(request, target);
		}
		
		public static function copyToClipboard(text:String):void
		{
			System.setClipboard(text);
		}
		
		public static function openWindowUrl(url:String, target:String = "_blank"):void
		{	
			Environment.openWindow(new URLRequest(url), target);
		}
	}
}