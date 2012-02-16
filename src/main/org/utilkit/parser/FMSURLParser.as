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
	import org.utilkit.util.StringUtil;

	public class FMSURLParser extends URLParser
	{
		protected var _useInstance:Boolean = false;
		protected var _applicationName:String;
		protected var _instanceName:String;
		protected var _streamName:String;
		protected var _streamType:String;
		
		protected static const APPLICATION_NAME_INDEX:uint = 0;
		protected static const INSTANCE_NAME_INDEX:uint = 2;
		protected static const STREAM_NAME_INDEX:uint = 4;
		
		protected static const DEFAULT_INSTANCE_NAME:String = "_definst_";
		
		protected static const MP4_STREAM:String = "mp4";
		protected static const ID3_STREAM:String = "id3";
		protected static const MP3_STREAM:String = "mp3";
		protected static const FLV_STREAM:String = "flv";
		
		protected static const QUERY_PARAM_STREAM_NAME:String = "streamName";
		protected static const QUERY_PARAM_STREAM_TYPE:String = "streamType";
		
		public function FMSURLParser(url:String=null)
		{
			super(url);
		}
		
		public function get instanceHostname():String
		{
			var applicationHost:String = this.hostname;
			
			if (this.applicationName != null || this.applicationName != "")
			{
				applicationHost += "/"+this.applicationName;
			}
			
			if (this.instanceName != null || this.instanceName != "")
			{
				applicationHost += "/"+this.instanceName;
			}
			
			return applicationHost;
		}
		
		public function get applicationName():String
		{
			return this._applicationName;
		}
		
		public function get instanceName():String
		{
			return this._instanceName;
		}
		
		public function get streamName():String
		{
			return this._streamName;
		}
		
		public function get streamType():String
		{
			return this._streamType;
		}
		
		public function get streamNameWithParameters():String
		{
			var queryString:String = "";
			var params:Array = new Array();
			
			if (this.parameters != null)
			{
				for (var i:int = (this.parameters.length - 1); i >= 0; i--)
				{
					var param:String = (this.parameters.getKeyAt(i) as String)+"="+(this.parameters.getItemAt(i) as String);
					
					params.push(param);
				}
			}

			if (params.length > 0)
			{
				params.reverse();
				
				queryString = "?"+params.join("&");
			}
			
			return this._streamName+queryString;
		}

		public override function parse(url:String):void
		{
			super.parse(url);
		
			this.parsePath();
			this.parseQuery();
		}
			
		protected function parsePath():void
		{
			if (this.path)
			{
				this._streamName = this.getParamValue(FMSURLParser.QUERY_PARAM_STREAM_NAME);
				this._streamType = this.getParamValue(FMSURLParser.QUERY_PARAM_STREAM_TYPE);
			}
			
			var result:Array = this.path.split(/(\/)/);
			//result = result..filter(function(item:*, index:int, array:Array):Boolean { return (item != "/" && item != "\\"); });
			
			if (result != null)
			{
				this._applicationName = result[FMSURLParser.APPLICATION_NAME_INDEX];
				this._instanceName = "";
				
				// are we using an instance?
				if (this.path.search(new RegExp("\/"+FMSURLParser.DEFAULT_INSTANCE_NAME, "i")) > -1)
				{
					this._useInstance = true;
				}
				
				var streamNameIndex:uint = FMSURLParser.STREAM_NAME_INDEX;
				
				if (this._useInstance)
				{
					var instanceIndex:uint = result.indexOf(FMSURLParser.DEFAULT_INSTANCE_NAME);
					
					for (var j:uint = (FMSURLParser.APPLICATION_NAME_INDEX + 1); j < instanceIndex; j++)
					{
						this._applicationName += result[j];
					}
					
					this._applicationName = StringUtil.rtrimWith(this._applicationName, '/');
					
					this._instanceName = result[instanceIndex];
					streamNameIndex = (instanceIndex + 1);
				}
				
				if (this._streamName == "" || this._streamName == null)
				{
					this._streamName = "";
					
					// search for the stream name
					for (var i:uint = streamNameIndex; i < result.length; i++)
					{
						this._streamName += result[i];
					}
					
					this._streamName = StringUtil.ltrimWith(this._streamName, '/');
					
					if (this._streamName == null || this._streamName == "")
					{
						// check if the stream name is specified in the query params
						this._streamName = this.getParamValue(FMSURLParser.QUERY_PARAM_STREAM_NAME);
					}
				}
				else
				{
					this._instanceName = result[FMSURLParser.INSTANCE_NAME_INDEX];
				}
				
				// type check
				if (this._streamName.search(/mp4:/i) > -1)
				{
					this._streamType = FMSURLParser.MP4_STREAM;
				}
				else if (this._streamName.search(/id3:/i) > -1)
				{
					this._streamType = FMSURLParser.ID3_STREAM;
				}
				else if (this._streamName.search(/mp3:/i) > -1)
				{
					this._streamType = FMSURLParser.MP3_STREAM;
				}
				else if (this._streamName.search(/flv:/i) > -1)
				{
					this._streamType = FMSURLParser.FLV_STREAM;
				}
				else
				{
					this._streamType = FMSURLParser.FLV_STREAM;
				}
				
				if (this._streamType == null || this._streamType == "")
				{
					// check if the stream type is specified in the query params
					this._streamType = this.getParamValue(FMSURLParser.QUERY_PARAM_STREAM_TYPE);
				}
			}
		}

		protected function parseQuery():void
		{
			
		}
	}
}
