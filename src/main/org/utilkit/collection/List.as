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
	public class List
	{
		protected var _source:Vector.<Object>;
		
		public function List(source:Array = null)
		{
			this._source = new Vector.<Object>(source);
			
			if (this._source == null)
			{
				this._source = new Vector.<Object>();
			}
		}
		
		public function get source():Vector.<Object>
		{
			return this._source;
		}
		
		public function set source(source:Vector.<Object>):void
		{
			this._source = source;
		}
		
		public function get length():int
		{
			return (this._source != null) ? this._source.length : 0;
		}
		
		public function getItemAt(index:int):*
		{
			if (index < 0 || index >= this.length)
			{
				// TODO: use a message formatter for exception messages
				//throw new ListException(ListException.OUT_OF_BOUNDS_ERR, "Index '"+index+"' out of bounds on Array");
			}
			
			return this.source[index];
		}
		
		public function setItemAt(item:*, index:int):*
		{
			if (index < 0 || index >= this.length)
			{
				//throw new ListException(ListException.OUT_OF_BOUNDS_ERR, "Index '"+index+"' out of bounds on Array");
			}
			
			var old:Object = this.source[index];
			
			this.source[index] = item;
			
			return old;
		}
		
		public function addItem(item:*):void
		{
			this.addItemAt(item, this.length);
		}
		
		public function addItemAt(item:*, index:int):void
		{
			if (index < 0 || index > this.length) {
				//throw new ListException(ListException.OUT_OF_BOUNDS_ERR, "Index '"+index+"' out of bounds on Array");
			}
			
			this.source.splice(index, 0, item);
		}
		
		public function getItemIndex(item:*):int
		{
			return this.getItemIndexFrom(item, 0);
		}
		
		public function getItemIndexFrom(item:*, start:int):int
		{
			if (start < 0 || start > this.length)
			{
				//throw new ListException(ListException.OUT_OF_BOUNDS_ERR, "Index '"+index+"' out of bounds on Array");
			}
			
			var i:int = 0;
			
			if (this._source != null)
			{
				var first:int = start;
				var last:int = this.length - 1;
				
				while (first <= last)
				{
					i = (first + last) / 2;
					
					var cur:* = this.source[i];
					
					if (cur == item)
					{
						return i;
					}
					else
					{
						first = i + 1;
					}
				}
				
				if (first > i)
				{
					i = first;
				}
			}
			
			return -1 - i;
		}
		
		public function removeItemAt(index:int):*
		{
			if (index < 0 || index >= this.length)
			{
				//throw new ListException(ListException.OUT_OF_BOUNDS_ERR, "Index '"+index+"' out of bounds on Array");
			}
			
			var old:* = this.source.splice(index, 1)[0];
			
			return old;
		}
		
		public function removeAll():void
		{
			if (this.length > 0)
			{
				this.source.splice(0, this.length);
			}
		}
	}
}
