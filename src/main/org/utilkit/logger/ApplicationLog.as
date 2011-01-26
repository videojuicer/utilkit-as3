package org.utilkit.logger
{
	public class ApplicationLog
	{
		protected var _applicationSignature:String;
			
		public function ApplicationLog(applicationSignature:String)
		{
			this._applicationSignature = applicationSignature;
		}
		
		public function get logMessages():Vector.<LogMessage>
		{
			var messages:Vector.<LogMessage> = new Vector.<LogMessage>();
			
			for (var i:int = 0; i < Logger.logMessages.length; i++)
			{
				if (Logger.logMessages[i].applicationSignature == this.applicationSignature)
				{
					messages.push(Logger.logMessages[i]);
				}
			}
			
			return messages;
		}
		
		public function get applicationSignature():String
		{
			return this._applicationSignature;
		}
		
		public function error(message:String, targetObject:Object = null):void
		{
			Logger.error(this.applicationSignature, message, targetObject);
		}
		
		public function warn(message:String, targetObject:Object = null):void
		{
			Logger.warn(this.applicationSignature, message, targetObject);
		}
		
		public function fatal(message:String, targetObject:Object = null):void
		{
			Logger.fatal(this.applicationSignature, message, targetObject);
		}
		
		public function info(message:String, targetObject:Object = null):void
		{
			Logger.info(this.applicationSignature, message, targetObject);
		}
		
		public function debug(message:String, targetObject:Object = null):void
		{
			Logger.debug(this.applicationSignature, message, targetObject);
		}
		
		public function log(message:String, targetObject:Object = null):void
		{
			Logger.log(this.applicationSignature, message, targetObject);
		}
		
		public function benchmark(message:String, targetObject:Object = null):void
		{
			Logger.benchmark(this.applicationSignature, message, targetObject);
		}
	}
}