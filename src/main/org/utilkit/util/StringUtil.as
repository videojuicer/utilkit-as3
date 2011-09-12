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
	public class StringUtil
	{
		public static function trim(str:String):String
		{
			return StringUtil.ltrim(StringUtil.rtrim(str));
		}
		
		public static function ltrim(str:String):String
		{
			for (var i:Number = 0; i < str.length; i++)
			{
				if (str.charCodeAt(i) > 32)
				{
					return str.substring(i);
				}
			}
			
			return "";
		}
		
		public static function rtrim(str:String):String
		{
			for (var i:Number = str.length; i > 0; i--)
			{
				if (str.charCodeAt(i - 1) > 32)
				{
					return str.substring(0, i);
				}
			}
			
			return "";
		}
		
		public static function stringsAreEqual(str1:String, str2:String, caseSensitive:Boolean):Boolean
		{
			if (caseSensitive)
			{
				return (str1 == str2);
			}
			else
			{
				return (str1.toLowerCase() == str2.toLowerCase());
			}
		}
	}
}
