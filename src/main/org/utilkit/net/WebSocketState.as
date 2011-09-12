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
	import flash.utils.ByteArray;

	public class WebSocketState
	{
		public static const STATE_HEAD_0:uint = 0;
		public static const STATE_HEAD_1:uint = 1;
		public static const STATE_HEAD_2:uint = 2;
		public static const STATE_HEAD_3:uint = 3;
		public static const STATE_HEAD_4:uint = 4;
		public static const STATE_HEAD_OPEN:uint = 5;
		public static const STATE_HEAD_ERROR:uint = 6;
		
		
		public static const STATE_MESSAGE_ERROR:uint = 10;
		public static const STATE_MESSAGE_RECEIVED:uint = 11;
		public static const STATE_MESSAGE_CLOSE:uint = 12;
		
		protected var _state:uint;
		protected var _position:int;
		protected var _data:ByteArray;
		
		public function WebSocketState(state:uint, position:int, data:ByteArray = null)
		{
			this._state = state;
			this._position = position;
			this._data = data;
		}
		
		public function get state():uint
		{
			return this._state;
		}
		
		public function get position():int
		{
			return this._position;
		}
		
		public function get data():ByteArray
		{
			return this._data;
		}
	}
}
