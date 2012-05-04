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
package org.utilkit
{
	/**
	 * Version class is used to hold a full version number, provides 
	 * a simple way to convert the <code>version</code> object into
	 * a string.
	 
	 * A <code>version</code> can be made up from a major, minor and
	 * a build uint. 
	 */
	public class Version
	{
		public var major:uint = 0;
		public var minor:uint = 0;
		public var text:String = '';
		public var date:String = '';
		
		public var build:uint = 0;
		
		/**
		 * Returns the version as a string in the following format;
		 * v<major>.<minor>.<build> or v2.1.457
		 */
		public function toString():String
		{
			return this.major + "." + this.minor + "." + this.build + " " + (this.text != null && this.text != "" ? " " + this.text : "") + (this.date != null && this.date != "" ? "(" + this.date + ")" : "");
		}
		
		public function toURLString():String
		{
			return this.major+"."+this.minor+this.text+"."+this.build;
		}
	}
}
