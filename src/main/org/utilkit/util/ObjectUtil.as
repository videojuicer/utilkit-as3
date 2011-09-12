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
package org.utilkit.util
{
	import flash.utils.ByteArray;
	
	import org.utilkit.crypto.Base64;

	/**
	 * ObjectManager provides a static helper that can be used to clone an <code>Object</code>.
	 */ 
	public class ObjectUtil
	{
		/**
		 * Clone's an Actionscript 3.0 Object using a ByteArray as a buffer. 
		 * 
		 * @param source Object to clone.
		 * 
		 * @return The cloned Object.
		 */
		public static function clone(source:Object):*
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(source);
			buffer.position = 0;
			
			var clone:Object = buffer.readObject();
			
			return clone;
		}
		
		public static function stripNullValues(source:Object):Object
		{
			var obj:Object = null;
			
			if (source != null)
			{
				obj = new Object();
				
				for (var key:String in source)
				{
					if (source[key] != null)
					{
						obj[key] = source[key];
					}
				}
			}
			
			return obj;
		}
		
		public static function merge(source:Object, withSource:Object):Object
		{
			var mergedObject:Object = new Object();
			
			ObjectUtil.copyPropertiesTo(source, mergedObject);
			ObjectUtil.copyPropertiesTo(withSource, mergedObject);
			
			return mergedObject;
		}
		
		public static function copyPropertiesTo(source:Object, to:Object):Object
		{
			for (var i:String in source)
			{
				to[i] = source[i];
			}
			
			return to;
		}
		
		public static function serialiseToString(value:Object):String
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(value);
			bytes.position = 0;
			
			var result:String = Base64.encodeByteArray(bytes);
			
			return result;
		}
		
		
		
		public static function deserialiseFromString(value:String):Object
		{
			var bytes:ByteArray = Base64.decodeToByteArray(value);
			bytes.position = 0;
			
			return bytes.readObject();
		}
	}
}
