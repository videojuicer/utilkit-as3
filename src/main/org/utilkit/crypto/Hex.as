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
 * The Original Code is the UtilKit library.
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
package org.utilkit.crypto
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
