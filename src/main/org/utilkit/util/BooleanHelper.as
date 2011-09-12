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
	public final class BooleanHelper
	{
		public static function stringToBoolean(value:String):Boolean
		{
			var result:Boolean = false;
			
			switch (value)
			{
				case "true":
				case "yes":
				case "yep":
				case "1":
				case 1:
					result = true;
					break;
				case "false":
				case "no":
				case "nope":
				case "0":
				case 0:
					result = false;
					break;
				default:
					result = new Boolean(value);
					break;
			}
			
			return result;
		}
	}
}
