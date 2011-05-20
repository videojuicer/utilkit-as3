package org.utilkit.util
{
	import flash.net.LocalConnection;
	import flash.system.System;

	public class Platform
	{
		public static function garbageCollection():void
		{
			try
			{
				new LocalConnection().connect('void');
				new LocalConnection().connect('void');
			}
			catch (e:*)
			{
				// nothing
			}
		}
		
		public static function gc():void
		{
			Platform.garbageCollection();
		}
		
		public static function memoryUsed():int
		{
			return System.totalMemory;
		}
	}
}