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
	import flash.external.ExternalInterface;
	
	import org.utilkit.collection.Hashtable;

	public class Benchmark
	{
		private static var __benchmarks:Hashtable = new Hashtable();
		private static var __results:Hashtable = new Hashtable();
		private static var __firstBenchmark:Number = 0;
		private static var __enabled:Boolean = true;
		
		public static function get enabled():Boolean
		{
			return Benchmark.__enabled;
		}
		
		public static function set enabled(value:Boolean):void
		{
			Benchmark.__enabled = value;
		}
		
		public static function begin(... identifier:Array):void
		{
			var id:String = Benchmark.buildID(identifier);
			var now:Number = new Date().time;
			
			Benchmark.__benchmarks.setItem(id, now);
			
			if (Benchmark.__firstBenchmark == 0)
			{
				Benchmark.__firstBenchmark = now;
			}
		}
		
		public static function finish(... identifier:Array):Number
		{
			var id:String = Benchmark.buildID(identifier);
			
			if (Benchmark.__benchmarks.hasItem(id))
			{
				var begin:Number = Benchmark.__benchmarks.getItem(id) as Number;
				var diff:Number = (new Date().time - begin);
				
				var results:Vector.<Number> = new Vector.<Number>();
				
				if (Benchmark.__results.hasItem(id))
				{
					results = Benchmark.__results.getItem(id) as Vector.<Number>;
				}
				
				results.push(diff);
				
				Benchmark.__results.setItem(id, results);
				
				Benchmark.__benchmarks.removeItem(id);
				
				var start:Number = (begin - Benchmark.__firstBenchmark);
				
				if (Benchmark.enabled)
				{
					ExternalInterface.call("player.benchmark", id, start, diff);
				}
				else
				{
					Logger.log("benchmark", id, start+"ms: "+diff+"ms");
				}
				
				return diff;
			}
			
			return 0;
		}
		
		public static function get results():Hashtable
		{
			return Benchmark.__results;
		}
		
		public static function resultsFor(... identifier:Array):Vector.<Number>
		{
			var id:String = Benchmark.buildID(identifier);
			var results:Vector.<Number> = null;
			
			if (Benchmark.__results.hasItem(id))
			{
				results = Benchmark.__results.getItem(id) as Vector.<Number>;
			}
			
			return results;
		}
		
		private static function buildID(... identifier:Array):String
		{
			var id:String = null;
			
			identifier = identifier[0];
			
			if (identifier != null && identifier.length > 0)
			{
				id = new String();
				
				for (var i:uint = 0; i < identifier.length; i++)
				{
					id += identifier[i] + ".";
				}
				
				if (id.charAt(id.length - 1) == ".")
				{
					id = id.substr(0, id.length - 1);
				}
			}
			
			return id;
		}
	}
}