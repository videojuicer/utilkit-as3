package org.utilkit.util
{
	import flash.utils.ByteArray;

	public final class ByteHelper
	{
		public static function writeUI24(buffer:ByteArray, value:uint):void
		{
			buffer.writeByte(value >> 16);
			buffer.writeByte(value >> 8 & 0xff);
			buffer.writeByte(value & 0xff);
		}
		
		public static function writeUI16(buffer:ByteArray, value:uint):void
		{
			buffer.writeByte(value >> 8);
			buffer.writeByte(value & 0xff);
		}
		
		public static function writeUI412(buffer:ByteArray, value1:uint, value2:uint):void
		{
			buffer.writeByte((value1 << 4) + (value2 >> 8));
			buffer.writeByte(value2 & 0xff);
		}
		
		public static function encode(buffer:ByteArray):String
		{
			var result:Array = new Array();
			var position:uint = buffer.position;
			
			for (buffer.position = 0; buffer.position < buffer.length - 1;)
			{
				result.push(buffer.readShort());
			}
			
			if (buffer.position != buffer.length)
			{
				result.push(buffer.readByte() << 8);
			}
			
			buffer.position = position;
			
			return String.fromCharCode.apply(null, result);
		}
		
		public static function decode(str:String):ByteArray
		{
			var result:ByteArray = new ByteArray();
			
			for (var i:uint = 0; i < str.length; i++)
			{
				result.writeShort(str.charCodeAt(i));
			}
			
			result.position = 0;
			
			return result;
		}
	}
}