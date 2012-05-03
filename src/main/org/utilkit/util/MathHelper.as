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
 * The Original Code is the SMILKit library.
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
 * ***** END LICENSE BLOCK ***** */
package org.utilkit.util
{
	import flash.geom.Rectangle;

	public class MathHelper
	{
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