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
	/**
	 * Stores a log message with the associated target object, level and message.
	 */
	public class LogMessage
	{
		protected var _level:String;
		protected var _message:String;
		protected var _targetObject:Object;
		
		protected var _applicationSignature:String;
		
		public function LogMessage(message:String, targetObject:Object, level:String = null, applicationSignature:String = null)
		{
			this._message = message;
			
			this._level = level;
			this._targetObject = targetObject;
			this._applicationSignature = applicationSignature;
			
			if ((level == null || level== "") && message.charAt(1) == " ")
			{
				switch (message.charAt(0).toLowerCase())
				{
					case "i":
						this._level = LogLevel.INFORMATION;
						break;
					case "w":
						this._level = LogLevel.WARNING;
						break;
					case "e":
						this._level = LogLevel.ERROR;
						break;
					case "f":
						this._level = LogLevel.FATAL;
						break;
					case "d":
						this._level = LogLevel.DEBUG;
						break;
				}
			}
		}
		
		public function get applicationSignature():String
		{
			return this._applicationSignature;
		}
		
		/**
		 * The level of the <code>LogMessage</code> as a <code>String</code>.
		 */
		public function get level():String
		{
			return this._level;
		}
		
		/**
		 * Target object linked to the <code>LogMessage</code>.
		 */
		public function get targetObject():Object
		{
			return this._targetObject;
		}
		
		/**
		 * Returns the <code>LogMessage</code> as a readable string.
		 * 
		 * @return Readable string of the <code>LogMessage</code>.
		 */
		public function toString():String
		{
			var s:String = "["+this.applicationSignature+"]["+LogLevel.stringForLevel(this._level).toLowerCase()+"] "+this._message;
			
			if (this._targetObject != null)
			{
				s += " on '"+this._targetObject.toString()+"'";
			}
			
			return s;
		}
	}
}
