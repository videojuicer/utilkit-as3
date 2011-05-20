package org.utilkit.logger
{
	import flash.system.Capabilities;
	import flash.system.System;
	
	import org.utilkit.logger.renderers.BrowserConsoleRenderer;
	import org.utilkit.logger.renderers.LogRenderer;
	import org.utilkit.logger.renderers.TraceRenderer;
	
	/**
	 * Provides logging functionality with support for broadcasting via the web browsers error console.
	 */
	public class Logger
	{
		/**
		* A list of LogRenderer instances to which log output should be directed.
		*/
		protected static var _logRenderers:Vector.<LogRenderer> = new Vector.<LogRenderer>();
		
		/**
		* If set to true, the Logger will retain all log messages in an array that may be accessed for pasting to the clipboard, 
		* sent to an error reporting API, or whatever you'd like to use it for. Use Logger.logMessages to access the list of raw
		* log message objects, or Logger.logHistory to pull a string containing the log output.
		*/
		protected static var _retainLogs:Boolean = true;
		
		/**
		* Used to store a history of LogMessage objects if _retainLogs is set to true.
		*/
		protected static var _logMessages:Vector.<LogMessage>;
		
		/**
		* Used to store a cached string render of the log history.
		*/
		protected static var _logHistory:String;
		
		/**
		 * List of ignored applications, these applications will still be able to log to the Logger but 
		 * wont be displayed in the renderers.
		 */
		protected static var _ignoreApplications:Vector.<String>;
		
		protected static var _alwaysBenchmark:Boolean = true;
		
		protected static var _lastBenchmark:Date = null;
		
		public static function get canRetainLogs():Boolean
		{
			return Logger._retainLogs;
		}
		
		public static function set canRetainLogs(retain:Boolean):void
		{
			Logger.canRetainLogs = retain;
		}
		
		public static function get logMessages():Vector.<LogMessage>
		{
			return Logger._logMessages;
		}
		
		public static function get logHistory():String
		{
			if(Logger._logMessages != null)
			{
				return Logger._logMessages.join("\r\n");
			}
			else
			{
				return "";
			}
		}
		
		public static function set logRenderers(renderers:Vector.<LogRenderer>):void
		{
			Logger._logRenderers = renderers;
		}
		
		public static function get logRenderers():Vector.<LogRenderer>
		{
			return Logger._logRenderers;
		}
		
		public static function get ignoreApplications():Vector.<String>
		{
			return Logger._ignoreApplications;
		}
		
		public static function set ignoreApplications(value:Vector.<String>):void
		{
			Logger._ignoreApplications = value;
		}
		
		public static function get alwaysBenchmark():Boolean
		{
			return Logger._alwaysBenchmark;
		}
		
		public static function set alwaysBenchmark(value:Boolean):void
		{
			Logger._alwaysBenchmark = value;
		}
			
		public static function addRenderer(renderer:LogRenderer):void
		{
			Logger.removeRenderer(renderer);
			Logger._logRenderers.push(renderer);
		}
		
		public static function removeRenderer(renderer:LogRenderer):void
		{
			var index:uint = Logger._logRenderers.indexOf(renderer);
			if(index > -1)
			{
				Logger._logRenderers.splice(index, 1);
			}
		}
		
		public static function defaultRenderers():void
		{
			Logger._logRenderers = new Vector.<LogRenderer>;
			
			if (Capabilities.isDebugger)
			{
				Logger.logRenderers.push(new TraceRenderer());
			}
			
			Logger.logRenderers.push(new BrowserConsoleRenderer());
		}
		
		/**
		 * Stores and prints the log message as an error.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 */
		public static function error(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			Logger.log(applicationSignature, message, targetObject, LogLevel.ERROR);
		}
		
		/**
		 * Stores and prints the log message as a warning.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 */
		public static function warn(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			Logger.log(applicationSignature, message, targetObject, LogLevel.WARNING);
		}
		
		/**
		 * Stores and prints the log message as a fatal error, a fatal error
		 * defines an error that stops the usual functionality.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 */
		public static function fatal(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			Logger.log(applicationSignature, message, targetObject, LogLevel.FATAL);
		}
		
		/**
		 * Stores and prints the log message as an informative message.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 */
		public static function info(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			Logger.log(applicationSignature, message, targetObject, LogLevel.INFORMATION);
		}
		
		/**
		 * Stores and prints the log message as a debug message.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 */
		public static function debug(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			Logger.log(applicationSignature, message, targetObject, LogLevel.DEBUG);
		}
		
		/**
		 * Create's a snapshot of the memory usage currently being used by SMILKit.
		 * 
		 * @return String Message with the current memory values of Megabytes and Kilobytes.
		 */
		public static function memorySnapshot():String
		{
			var totalMemory:uint = System.totalMemory;
			
			var memoryMB:Number = (totalMemory / 1024 / 1024 * 100) / 100;
			var memoryKB:Number = (totalMemory / 1024);
			
			memoryMB = (memoryMB > 0.0) ? int(memoryMB + 0.5) : int(memoryMB - 0.5);
			memoryKB = (memoryKB > 0.0) ? int(memoryKB + 0.5) : int(memoryKB - 0.5);
			
			return "Memory Snapshot: "+memoryMB+" MB ("+memoryKB+" kB)";
		}
		
		public static function benchmark(applicationSignature:String, message:String, targetObject:Object = null):void
		{
			var date:Date = new Date();
			var timeString:String = date.hoursUTC+":"+date.minutesUTC+":"+date.secondsUTC+":"+date.millisecondsUTC;
			var timeTaken:Number = 0;
			
			if (Logger._lastBenchmark != null)
			{
				timeTaken = date.time - Logger._lastBenchmark.time;
			}
			
			message = timeString+" ("+timeTaken+"ms) - "+message;
			
			Logger.log(applicationSignature, message, targetObject, LogLevel.BENCHMARK);
			
			Logger._lastBenchmark = date;
		}
		
		/**
		 * Actually stores and prints the log message in the Logger.
		 * 
		 * @param message The message <code>String</code>
		 * @param targetObject The target object associated with the log message.
		 * @param level Level of the log message. 
		 */
		public static function log(applicationSignature:String, message:String, targetObject:Object = null, level:String = null):void
		{
			if(Logger._logRenderers != null)
			{
				var logMessage:LogMessage = new LogMessage(message, targetObject, level, applicationSignature);
				
				// Stash in the history
				if(Logger.canRetainLogs)
				{
					if(Logger._logMessages == null)
					{
						Logger._logMessages = new Vector.<LogMessage>;
					}
					Logger._logMessages.push(logMessage);
				}
				
				if (Logger._ignoreApplications == null || Logger._ignoreApplications.indexOf(applicationSignature) == -1 || (level == LogLevel.BENCHMARK && Logger._alwaysBenchmark))
				{
					// for now;
					for(var i:uint = 0; i < Logger._logRenderers.length; i++)
					{
						var renderer:LogRenderer = Logger._logRenderers[i];
						renderer.render(logMessage);
					}
				}
			}
		}
	}
}