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
	import by.blooddy.crypto.Base64;
	
	import flash.utils.ByteArray;
	
	public class Base64
	{
		public static function encode(data:String):String
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			
			return Base64.encodeByteArray(bytes);
		}
		
		public static function encodeByteArray(data:ByteArray):String
		{
			data.position = 0;
			
			return by.blooddy.crypto.Base64.encode(data, false);
		}
		
		public static function decode(data:String):String
		{
			try
			{
				var bytes:ByteArray = Base64.decodeToByteArray(data);
				bytes.position = 0;
				
				return bytes.readUTFBytes(bytes.length);
			}
			catch (e:Error)
			{
				
			}
			
			return "";
		}
		
		public static function decodeToByteArray(data:String):ByteArray
		{
			return by.blooddy.crypto.Base64.decode(data);
		}
	}
}
