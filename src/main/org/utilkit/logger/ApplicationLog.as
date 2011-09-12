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
package org.utilkit.logger
{
	public class ApplicationLog
	{
		protected var _applicationSignature:String;
			
		public function ApplicationLog(applicationSignature:String)
		{
			this._applicationSignature = applicationSignature;
		}
		
		public function get logMessages():Vector.<LogMessage>
		{
			var messages:Vector.<LogMessage> = new Vector.<LogMessage>();
			
			for (var i:int = 0; i < Logger.logMessages.length; i++)
			{
				if (Logger.logMessages[i].applicationSignature == this.applicationSignature)
				{
					messages.push(Logger.logMessages[i]);
				}
			}
			
			return messages;
		}
		
		public function get applicationSignature():String
		{
			return this._applicationSignature;
		}
		
		public function error(message:String, targetObject:Object = null):void
		{
			Logger.error(this.applicationSignature, message, targetObject);
		}
		
		public function warn(message:String, targetObject:Object = null):void
		{
			Logger.warn(this.applicationSignature, message, targetObject);
		}
		
		public function fatal(message:String, targetObject:Object = null):void
		{
			Logger.fatal(this.applicationSignature, message, targetObject);
		}
		
		public function info(message:String, targetObject:Object = null):void
		{
			Logger.info(this.applicationSignature, message, targetObject);
		}
		
		public function debug(message:String, targetObject:Object = null):void
		{
			Logger.debug(this.applicationSignature, message, targetObject);
		}
		
		public function log(message:String, targetObject:Object = null):void
		{
			Logger.log(this.applicationSignature, message, targetObject);
		}
		
		public function benchmark(message:String, targetObject:Object = null):void
		{
			Logger.benchmark(this.applicationSignature, message, targetObject);
		}
	}
}
