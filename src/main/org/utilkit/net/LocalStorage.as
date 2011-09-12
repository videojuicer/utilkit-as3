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
package org.utilkit.net
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class LocalStorage
	{
		public const STORE_NAME_PREFIX:String = "vj_";
		
		protected var _storeName:String = null;
		
		protected var _sharedObject:SharedObject = null;
		
		protected var _active:Boolean = false;
		
		public function LocalStorage(storeName:String)
		{
			this._storeName = storeName;
		}
		
		public function get storeName():String
		{
			return this._storeName;
		}
		
		public function get active():Boolean
		{
			return this._active;
		}
		
		protected function get store():Object
		{
			return this._sharedObject.data;
		}
		
		public function getProperty(name:String):Object
		{
			var result:Object = null;
			
			this.rebuild();
			
			if (this.active)
			{
				if (this.store.hasOwnProperty(name))
				{
					result = this.store[name];
				}
			}
			
			return result;
		}
		
		public function getPropertyAsBoolean(name:String, fail:Boolean = false):Boolean
		{
			var property:Object = this.getProperty(name);
			var result:Boolean = fail;
			
			if (property != null && property is Boolean)
			{
				result = (new Boolean(property));
			}
			
			return result;
		}
		
		public function getPropertyAsNumber(name:String, fail:Number = NaN):Number
		{
			var property:Object = this.getProperty(name);
			var result:Number = fail;
			
			if (property != null && property is Number)
			{
				result = (new Number(property));
			}
			
			return result;
		}
		
		public function getPropertyAsString(name:String, fail:String = null):String
		{
			var property:Object = this.getProperty(name);
			var result:String = fail;
			
			if (property != null && property is String)
			{
				result = (new String(property));
			}
			
			return result;
		}
		
		public function setProperty(name:String, value:Object):Boolean
		{
			var status:String = null;
			var result:Boolean = false;
			
			this.rebuild();
			
			if (this.active)
			{
				this.store[name] = value;
				
				try
				{
					status = this._sharedObject.flush(100);
				}
				catch (e:Error)
				{
					result = false;
				}
				
				if (status != null)
				{
					switch (status)
					{
						case SharedObjectFlushStatus.PENDING:
							result = false;
							break;
						case SharedObjectFlushStatus.FLUSHED:
							result = true;
							break;
					}
				}
			}
			
			return result;
		}
		
		protected function rebuild():void
		{
			if (this._sharedObject == null)
			{
				if (this._storeName != null && this._storeName != "")
				{
					this._sharedObject = SharedObject.getLocal(STORE_NAME_PREFIX + this._storeName, '/', false);
					
					if (this._sharedObject != null)
					{
						this._active = true;
					}
				}
			}
		}
	}
}
