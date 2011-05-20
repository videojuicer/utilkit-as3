package org.utilkit.util
{
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	import flash.system.System;

	public class Platform
	{
		public static function get cpuArchitecture():String
		{
			var architecture:String = "unknown";
			
			// cpuArchitecture property can return the following strings: "PowerPC", "x86", "SPARC", and "ARM". The server string is ARCH.
			// alpha, arm, arm32, hppa1.1, m68k, mips, ppc, rs6000, vax, x86, unknown.
			switch (Capabilities.cpuArchitecture)
			{
				case "PowerPC":
					architecture = "ppc";
					break;
				case "x86":
					architecture = "x86";
					break;
				case "x64":
					architecture = "x64";
					break;
				case "SPARC":
					architecture = "mips";
					break;
				case "ARM":
					architecture = "arm";
					break;
			}
			
			return architecture;
		}
		
		public static function get operatingSystem():String
		{
			var operatingSystem:String = "unknown";
			
			// [Read Only] Specifies the current operating system. The os property can return the following strings: "Windows XP", "Windows 2000", "Windows NT", "Windows 98/ME", "Windows 95", "Windows CE" (available only in Flash Player SDK, not in the desktop version), "Linux", and "Mac OS X.Y.Z" (where X.Y.Z is the version number, for example: Mac OS 10.5.2). The server string is OS.
			// Do not use Capabilities.os to determine a capability based on the operating system if a more specific capability property exists. Basing a capability on the operating system is a bad idea, since it can lead to problems if an application does not consider all potential target operating systems. Instead, use the property corresponding to the capability for which you are testing. For more information, see the Capabilities class description.
			
			var os:String = Capabilities.os;
			var sections:Array = os.split(" ");
			
			switch (sections[0])
			{
				case "Linux":
					operatingSystem = "linux";
					break;
				case "Mac":
					operatingSystem = "macos";
					break;
				case "iPhone":
					operatingSystem = "arm32";
					break;
				case "Windows":
					var windows:String = sections.slice(1).join(" ");
					
					operatingSystem = "win";
					
					switch (windows)
					{
						case "Mobile":
							operatingSystem = "";
							break;
						case "CEPC":
							operatingSystem = "";
							break;
						case "PocketPC":
							operatingSystem = "";
							break;
						case "SmartPhone":
							operatingSystem = "";
							break;
						case "CE":
							operatingSystem = "win16";
							break;
						case "ME":
							operatingSystem = "win16";
							break;
						case "2000":
							operatingSystem = "winnt";
							break;
						case "NT":
							operatingSystem = "winnt";
							break;
						case "95":
							operatingSystem = "win9x";
							break;
						case "98":
							operatingSystem = "win9x";
							break;
						case "XP":
							operatingSystem = "";
							break;
						case "XP 64":
							operatingSystem = "";
							break;
						case "Server 2003":
							operatingSystem = "";
							break;
						case "Server 2003 R2":
							operatingSystem = "";
							break;
						case "Home Server":
							operatingSystem = "";
							break;
						case "Server 2008":
							operatingSystem = "";
							break;
						case "Server 2008 R2":
							operatingSystem = "";
							break;
						case "Vista":
							operatingSystem = "";
							break;
						case "7":
							operatingSystem = "";
							break;
					}
					break;
			}
			
			return operatingSystem;
		}
		
		public static function garbageCollection():void
		{
			try
			{
				new LocalConnection().connect('void');
				new LocalConnection().connect('void');
			}
			catch (e:*)
			{
				return;
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