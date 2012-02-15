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
	public class NumberHelper
	{
		public static function withinTolerance(a:Number, b:Number, tolerance:Number = 1.0):Boolean
		{
			var diff:Number = Math.abs(a - b);
			
			return (diff <= tolerance);
		}
		
		public static function zeroPad(number:int, minWidth:int):String
		{
			var ret:String = "" + number.toString();
			
			while(ret.length < minWidth)
			{
				ret = "0" + ret;
			}
			
			return ret;
		}
		
		public static function isNumeric(value:Object):Boolean
		{
			return !isNaN(parseInt(value.toString()));
		}
		
		public static function toHumanReadableString(value:Number):String
		{
			var str:String = Math.round(value).toString();
			var result:String = '';
			
			while (str.length > 3)
			{
				var chunk:String = str.substr(-3);
				
				str = str.substr(0, str.length - 3);
				
				result = ',' + chunk + result
			}
			
			if (str.length > 0)
			{
				result = str + result
			}
			
			return result
		}
		
		/**
		 * Checks if the specified value is a percentage by checking for 
		 * the % symbol.
		 * 
		 * @param value Value is check.
		 * 
		 * @return True if the value is a percentage, false otherwise.
		 */
		public static function isPercentage(value:*):Boolean
		{
			var s:String = value.toString();
			
			return (s.lastIndexOf("%") != -1);
		}
		
		/**
		 * Converts a percentage number into an integer by removing the trailing %.
		 * 
		 * @param value Value to parse into an integer.
		 * 
		 * @return The integer result of the specified value.
		 */
		public static function percentageToInteger(value:*):uint
		{
			var s:String = value.toString();
			var v:String = s.substr(0, s.indexOf("%"));
			
			return parseInt(v);
		}
		
		public static function calculateAspectRatio(width:Number, height:Number):Number
		{
			return (width / height);
		}
	}
}
