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
	}
}