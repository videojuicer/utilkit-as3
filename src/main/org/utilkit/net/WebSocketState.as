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