package org.utilkit.net
{
	import flash.utils.ByteArray;
	
	public class WebSocketHeadState extends WebSocketState
	{
		protected var _message:String;
		
		public function WebSocketHeadState(state:uint, position:int, message:String = null)
		{
			super(state, position, data);
			
			this._message = message;
		}
		
		public function get message():String
		{
			return this._message;
		}
	}
}