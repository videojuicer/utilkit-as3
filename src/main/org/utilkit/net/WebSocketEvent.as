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
package org.utilkit.net
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class WebSocketEvent extends Event
	{
		public static var OPEN:String = "webSocketEventOnOpen";
		public static var MESSAGE:String = "webSocketEventOnMessage";
		public static var ERROR:String = "webSocketEventOnError";
		public static var CLOSE:String = "webSocketEventOnClose";
		
		protected var _message:String;
		protected var _data:ByteArray;
		
		public function WebSocketEvent(type:String, message:String, data:ByteArray = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this._message = message;
			this._data = data;
		}
		
		public function get message():String
		{
			return this._message;
		}
		
		public function get data():ByteArray
		{
			return this._data;
		}
		
		public override function clone():Event
		{
			return (this as Event);
		}
	}
}
