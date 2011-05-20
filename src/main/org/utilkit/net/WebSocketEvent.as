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