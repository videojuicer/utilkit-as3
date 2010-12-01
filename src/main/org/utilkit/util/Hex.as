package org.utilkit.util
{
	import flash.utils.ByteArray;

	public class Hex
	{
		private static var __hexChars:Array = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' ];
		
		public static function dumpBytes(bytes:ByteArray):String
		{
			var result:String = "";
			
			for (var i:int = 0; i < bytes.length; i++)
			{
				var bit:String = "";
				bit += Hex.__hexChars[(bytes[i] & 0x00F0) >> 4];
				bit += Hex.__hexChars[bytes[i] & 0x000F];
				bit += ":"+String.fromCharCode(bytes[i]);
				bit += " ";
				
				result += bit;
			}
			
			return result;
		}
		
		public static function rgbToHex(red:int, green:int, blue:int):uint
		{
			return (red << 16 ^ green << 8 ^ blue);
		}
	}
}