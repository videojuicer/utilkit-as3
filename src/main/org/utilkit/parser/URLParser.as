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
package org.utilkit.parser
{
	import org.utilkit.collection.Hashtable;

	/**
	 * Parses a URL and provides helper properties for access to the different URL pieces.
	 */ 
	public class URLParser
	{
		protected var _url:String;
		
		protected var _host:String = "";
		protected var _port:String = "";
		protected var _protocol:String = "";
		protected var _path:String = "";
		protected var _parameters:Hashtable;
		
		public function URLParser(url:String = null)
		{
			if (url != null)
			{
				this.parse(url);
			}
		}
		
		/**
		 * The original URL passed into the parser.
		 */
		public function get url():String
		{
			return this._url;
		}
		
		public function get hostname():String
		{
			var hostname:String = this.protocol+"://"+this.host;
			
			if (this.port != "")
			{
				hostname += ":"+this.port;
			}
			
			return hostname;
		}
		
		/**
		 * The hostname of the parsed URL.
		 */
		public function get host():String
		{
			return this._host;
		}
		
		/**
		 * Port number as a string of the parsed URL.
		 */
		public function get port():String
		{
			return this._port;
		}
		
		/**
		 * The protocol used in the URL.
		 */
		public function get protocol():String
		{
			return this._protocol;
		}
		
		/**
		 * The path defined in the parsed URL.
		 */
		public function get path():String
		{
			return this._path;
		}
		
		/**
		 * The parameters as an <code>Hashtable</code> from the parsed URL.
		 */
		public function get parameters():Hashtable
		{
			return this._parameters;
		}
		
		/**
		 * The file extension used in the parsed URL.
		 */
		public function get extension():String
		{
			var i:int = this.path.lastIndexOf('.');
			
			if (i != -1)
			{
				return this.path.substr(i);
			}
			
			return null;
		}
		
		/**
		 * The inline extension, available when a URL contains
		 * the extension / file type in the path rather than at the end.
		 * 
		 * Looks for 'extension:' at the start of the path.
		 */
		public function get inlineExtension():String
		{
			var i:int = this.path.indexOf(":");
			
			if (i != -1)
			{
				var k:String = this.path.substr(0, i);
				var s:int = k.lastIndexOf("/");
				
				if (s == -1)
				{
					s = 0;
				}
				else
				{
					s++;
				}
				
				return k.substr(s, i);
			}
			
			return null
		}
		
		public function getParamValue(param:String):String
		{
			if (this._parameters == null)
			{
				return "";
			}
			
			return this._parameters.getItem(param);
		}
		
		/**
		 * Parses the specified URL <code>String</code> and populates the <code>URLParser</code>
		 * instance with the extracted data. 
		 * 
		 * @param url The URL <code>String</code> to parse.
		 */
		public function parse(url:String):void
		{
			this._url = url;
			
			var reg:RegExp = /(?P<protocol>[a-zA-Z]+) : \/\/  (?P<host>[^:\/]*) (:(?P<port>\d+))?  ((?P<path>[^?]*))? ((?P<parameters>.*))? /x;
			var results:Array = reg.exec(this._url);
			
			this._protocol = results.protocol;
			this._host = results.host;
			this._port = results.port;
			this._path = results.path;
			
			if (this._path.charAt(0) == "/")
			{
				this._path = this._path.substr(1, this._path.length);
			}
			
			var params:String = results.parameters;
			
			if (params != "")
			{
				this._parameters = new Hashtable();
				
				if (params.charAt(0) == "?")
				{
					params = params.substring(1);
				}
				
				var parameters:Array = params.split("&");
				
				for each (var s:String in parameters)
				{
					var p:Array = s.split("=");
					
					this._parameters.setItem(p[0], p[1]);
				}
			}
		}
	}
}
