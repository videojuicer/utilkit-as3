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
 * The Original Code is the SMILKit library / StyleKit library / UtilKit library.
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
package org.utilkit.collection
{
	public class Hashtable extends List
	{
		protected var _keys:List = new List();
		
		public function Hashtable()
		{
			super(null);
		}
		
		public function get isEmpty():Boolean
		{
			return (this._keys.length == 0);
		}
		
		public function getItem(key:*):*
		{
			var i:int = this.getNamedIndex(key);
			
			if (i == -1)
			{
				return null;
			}
			else
			{
				return this.getItemAt(i);
			}
		}
		
		public function getKeyAt(index:int):*
		{
			if (index > this.length || index < 0)
			{
				return null;
			}
			
			return this._keys.getItemAt(index);
		}
		
		public function getNamedIndex(key:*):int
		{
			if (this.hasItem(key))
			{
				for (var i:int = this._keys.length - 1; i >= 0; i--)
				{
					if (key == this._keys.getItemAt(i))
					{
						return i;
					}
				}
			}
			
			return -1;
		}
		
		public function setItem(key:*, value:*):void
		{
			var i:int = this.getNamedIndex(key);
			
			if (i == -1)
			{
				this._keys.addItem(key);
				this.addItem(value);
			}
			else
			{
				this.setItemAt(value, i);
			}
		}
		
		public function removeItem(key:*):void
		{
			var i:int = this.getNamedIndex(key);
			
			if (i != -1)
			{
				this._keys.removeItemAt(i);
				this.removeItemAt(i);
			}
		}
		
		public function hasItem(key:*):Boolean
		{
			if (this._keys.length > 0)
			{
				for (var i:int = this._keys.length -1; i >= 0; i--)
				{
					var newKey:* = this._keys.getItemAt(i);
					
					if (key == newKey)
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}
}
