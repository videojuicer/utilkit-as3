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
package org.utilkit.logger
{
	/**
	 * LogLevel describes the various levels of log reports, and provides helpers
	 * for conversation.  
	 */
	public class LogLevel
	{
		public static var INFORMATION:String = "logMessageInformation";
		public static var WARNING:String = "logMessageWarning";
		public static var ERROR:String = "logMessageError";
		public static var FATAL:String = "logMessageFatal";
		public static var DEBUG:String = "logMessageDebug";
		public static var BENCHMARK:String = "logMessageBenchmark";
		
		/**
		 * Returns an integer index for the specified string level.
		 * 
		 * @return Index of the level specified as an integer.
		 */
		public static function indexForLevel(level:String):int
		{
			switch (level)
			{
				case LogLevel.INFORMATION:
					return 1;
					break;
				case LogLevel.WARNING:
					return 2;
					break;
				case LogLevel.ERROR:
					return 3;
					break;
				case LogLevel.FATAL:
					return 4;
					break;
				case LogLevel.DEBUG:
					return 5;
					break;
				case LogLevel.BENCHMARK:
					return 6;
					break;
			}
			
			return 0;
		}
		
		/**
		 * Returns a string for the specified int level.
		 * 
		 * @return String of the level specified.
		 */
		public static function stringForLevel(level:String):String
		{
			switch (level)
			{
				case LogLevel.INFORMATION:
					return "Info";
					break;
				case LogLevel.WARNING:
					return "Warning";
					break;
				case LogLevel.ERROR:
					return "Error";
					break;
				case LogLevel.FATAL:
					return "Fatal";
					break;
				case LogLevel.DEBUG:
					return "Debug";
					break;
				case LogLevel.BENCHMARK:
					return "Benchmark";
					break;
			}
			
			return "Unknown";
		}
	}
}
