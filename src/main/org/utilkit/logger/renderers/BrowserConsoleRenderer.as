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
package org.utilkit.logger.renderers
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	import org.utilkit.logger.LogLevel;
	import org.utilkit.logger.LogMessage;

	public class BrowserConsoleRenderer extends LogRenderer
	{
		protected var _consoleAvailable:Boolean = false;
		protected var _consoleChecked:Boolean = false;
		
		public function BrowserConsoleRenderer()
		{
			super();
		}
		
		public override function render(message:LogMessage):void
		{
			if (!this._consoleChecked)
			{
				this.checkForConsole();
			}
			
			if (this._consoleAvailable)
			{
				switch (message.level)
				{
					case LogLevel.DEBUG:
						ExternalInterface.call("console.debug", message.toString());
						break;
					case LogLevel.ERROR:
						ExternalInterface.call("console.error", message.toString());
						break;
					case LogLevel.FATAL:
						ExternalInterface.call("console.error", message.toString());
						break;
					case LogLevel.INFORMATION:
						ExternalInterface.call("console.info", message.toString());
						break;
					case LogLevel.WARNING:
						ExternalInterface.call("console.warn", message.toString());
						break;
					default:
						ExternalInterface.call("console.log", message.toString());
						break;
				}
			}
		}
		
		protected function checkForConsole():Boolean
		{
			var playerType:String = Capabilities.playerType.toLowerCase();
			var browserAvailable:Boolean = (playerType == "plugin" || playerType == "activex");
			
			this._consoleAvailable = false;
			
			if (browserAvailable && ExternalInterface.available)
			{
				var consoleAvailable:Boolean = false;
				
				try
				{
					consoleAvailable = ExternalInterface.call("function(){ return typeof window.console == 'object' && (typeof console.info == 'function' || typeof console.info == 'object'); }");
				}
				catch (e:Error)
				{
					
				}
				finally
				{
					if (consoleAvailable)
					{
						this._consoleAvailable = true;
					}
				}
			}
			
			this._consoleChecked = true;
			
			return this._consoleAvailable;
		}
	}
}
