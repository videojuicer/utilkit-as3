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