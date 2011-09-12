/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 * 
 * The Original Code is the SMILKit library / StyleKit library / UtilKit library.
 * 
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 * 
 * ***** END LICENSE BLOCK ******/
package org.utilkit.util
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import org.utilkit.UtilKit;

	public class Environment
	{
		protected static var __stageRoot:Stage;
		
		public static function attachToStageRoot(stage:Stage):void
		{
			Environment.__stageRoot = stage;
		}
		
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
			if (Environment.isFullscreenMode)
			{
				UtilKit.logger.warn("Opening URL in browser, but currently running in fullscreen mode. Dropping down to window mode now ...");
				
				Environment.toggleScreenMode(true);
			}
			
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
		
		public static function get isFullscreenMode():Boolean
		{
			return (Environment.__stageRoot != null && Environment.__stageRoot.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		public static function get isWindowMode():Boolean
		{
			return (Environment.__stageRoot != null && Environment.__stageRoot.displayState == StageDisplayState.NORMAL);
		}
		
		public static function get screenSize():String
		{
			return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}
		
		public static function get language():String
		{
			return Capabilities.language;
		}
		
		public static function toggleScreenMode(exceptFullscreen:Boolean = false):void
		{
			if (Environment.__stageRoot != null)
			{
				var stage:Stage = Environment.__stageRoot;
				
				stage.fullScreenSourceRect = null;
				
				if(stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					stage.displayState = StageDisplayState.NORMAL;
				}
				else if (!exceptFullscreen)
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
			}
		}
	}
}
