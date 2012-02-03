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
	BUILD::SSL
	{
		import com.hurlant.crypto.tls.TLSConfig;
		import com.hurlant.crypto.tls.TLSEngine;
		import com.hurlant.crypto.tls.TLSSecurityParameters;
		import com.hurlant.crypto.tls.TLSSocket;
	}
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.LocalConnection;
	import flash.net.Socket;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.utils.URLUtil;
	
	import org.utilkit.UtilKit;
	import org.utilkit.crypto.MD5;
	import org.utilkit.net.WebSocketEvent;
	import org.utilkit.util.Hex;

	[Event(name="message", type="org.vjuicer.io.WebSocketEvent")]
	[Event(name="open", type="org.vjuicer.io.WebSocketEvent")]
	[Event(name="error", type="org.vjuicer.io.WebSocketEvent")]
	[Event(name="close", type="org.vjuicer.io.WebSocketEvent")]
	public class WebSocket extends EventDispatcher
	{
		protected var _url:String;
		
		protected var _protocol:String;
		protected var _hostname:String;
		protected var _port:uint;
		protected var _path:String;
		protected var _origin:String;
		
		protected var _timeout:uint = 5000;
		
		protected var _expectedDigest:String;
		protected var _buffer:ByteArray;
		protected var _dataQueue:Vector.<ByteArray>;

		protected var _socket:Socket;
		
		BUILD::SSL
		{
			protected var _secureSocket:TLSSocket;
			protected var _secureConfiguration:TLSConfig;
		}
		
		protected var _readyState:uint = WebSocket.CONNECTING;
		protected var _headerState:uint = WebSocket.CONNECTING;
		protected var _bufferedAmount:int = WebSocket.CONNECTING;
		
		private var _noiseCharacters:Vector.<String>;
		
		// ready states
		public static const CONNECTING:uint = 0;
		public static const OPEN:uint = 1;
		public static const CLOSING:uint = 2;
		public static const CLOSED:uint = 3;
		
		public function WebSocket(url:String = null, protocols:Vector.<String> = null)
		{
			this._socket = new Socket();
			this._buffer = new ByteArray();
			this._dataQueue = new Vector.<ByteArray>();
			
			if (url != null)
			{
				this.setup(url, protocols);
			}
		}
		
		public function setup(url:String, protocols:Vector.<String> = null):void
		{
			this._url = url;
			
			var matches:Array = this.url.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?$/);
			
			if (!matches)
			{
				throw new ArgumentError("Invalid URL specified.");
			}
			
			this._protocol = matches[1].toString().toLowerCase();
			this._hostname = matches[2];
			this._port = parseInt(matches[4] || "80");
			this._path = matches[5] || "/";
			
		
			if (BUILD::SSL == false && this.protocol.toLowerCase() == "wss")
			{
				throw new IllegalOperationError("WSS protocol not supported, SSL libraries not available " + BUILD::SSL);
				
				return;
			}
			
			if (this.protocol.toLowerCase() != "ws" && this.protocol.toLowerCase() != "wss")
			{
				throw new IllegalOperationError(this.protocol+" protocol not supported.");
				
				return;
			}
			
			this.initNoiseCharacters();
			this.findOrigin();
		}
			
		public function connect():void
		{
			//this.loadPolicyFile();

			this._socket = new Socket();
			this._buffer = new ByteArray();
			this._dataQueue = new Vector.<ByteArray>();
			
			this._socket.timeout = this.timeout;
			
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
			
			BUILD::SSL
			{
				if (this.protocol == "wss")
				{
					this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
					
					this._secureConfiguration = new TLSConfig(TLSEngine.CLIENT, null, null, null, null, null, TLSSecurityParameters.PROTOCOL_VERSION);
					
					this._secureConfiguration.trustAllCertificates = true;
					this._secureConfiguration.trustSelfSignedCertificates = true;
					this._secureConfiguration.ignoreCommonNameMismatch = true;
			
					this._secureSocket = new TLSSocket();
					
					this._secureSocket.timeout = this.timeout;
					
					this._secureSocket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
				}
			}

			this._socket.addEventListener(Event.CONNECT, this.onSocketConnect);
			this._socket.addEventListener(Event.CLOSE, this.onSocketClose);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR, this.onSocketIOError);
			this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecurityError);
			
			this._readyState = WebSocket.CONNECTING;
			
			UtilKit.logger.debug("WebSocket connecting to "+this.hostname+" "+this.port);
			
			this._socket.connect(this.hostname, this.port);
		}
		
		protected function onSocketConnect(e:Event):void
		{
			UtilKit.logger.debug("WebSocket received connect response, sending reply ...");
			
			BUILD::SSL
			{
				if (this.protocol == "wss")
				{
					UtilKit.logger.benchmark("Starting TLS on WebSocket connection ..");
					this._secureSocket.startTLS(this._socket, this.hostname, this._secureConfiguration);
				}
			}
			
			var key1:String = this.generateKey();
			var key2:String = this.generateKey();
			var key3:String = this.generateKey3();
			
			this._expectedDigest = this.generateSecurityDigest(key1, key2, key3);
			
			var headers:Vector.<String> = new Vector.<String>();
			
			headers.push("GET "+this.path+" HTTP/1.1");
			headers.push("Upgrade: WebSocket");
			headers.push("Connection: Upgrade");
			headers.push("Host: "+this.hostname+(this.port == 80 ? "" : ":"+this.port.toString()));
			headers.push("Origin: "+this.origin);
			headers.push("Sec-WebSocket-Key1: "+key1);
			headers.push("Sec-WebSocket-Key2: "+key2);
			
			var header:String = headers.join("\r\n")+"\r\n\r\n";
			
			UtilKit.logger.debug("Sending Header: \n"+header);
			
			this.socket.writeUTFBytes(header);
			
			UtilKit.logger.debug("Sending Key3: "+key3);
			
			this.writeBytes(key3);

			UtilKit.logger.benchmark("Header sent and socket flushed");
			this.socket.flush();
		}
		
		protected function onSocketClose(e:Event):void
		{
			this._readyState = WebSocket.CLOSED;

			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.CLOSE, "Connection closed"));
		}
		
		protected function onSocketData(e:ProgressEvent):void
		{
			var position:int = this._buffer.length;
		
			UtilKit.logger.debug("Received socket data from "+position+" starting to process messages");
			
			this.socket.readBytes(this._buffer, position);
			
			// reset the position so we always read from the begining of the stack, just incase the last batch of messages
			// we processed contained the starting byte sequence for our new batch
			position = 0;
			
			UtilKit.logger.debug("Finished creating buffer with a total length of "+this._buffer.length);
			
			if (this._headerState <= 4)
			{
				// process head
				var heads:Vector.<WebSocketHeadState> = this.processHeader(this._buffer, position);
			
				var headReadPosition:int = 0;
				
				for (var k:int = 0; k < heads.length; k++)
				{
					var head:WebSocketHeadState = heads[k];

					UtilKit.logger.debug("WebSocket Header: "+head.state+" Message: "+head.message);
					
					switch (head.state)
					{
						case WebSocketState.STATE_HEAD_ERROR:
							this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, head.message));
							break;
						case WebSocketState.STATE_HEAD_OPEN:
							this._headerState = head.state;
							
							this.dispatchEvent(new WebSocketEvent(WebSocketEvent.OPEN, head.message));
							break;
					}
					
					if (head.position > headReadPosition)
					{
						headReadPosition = head.position;
					}
				}
				
				// remove the processed data from the buffer
				this._buffer = WebSocket.removeBufferBefore(this._buffer, headReadPosition);
			}
			
			if (this._headerState > 4)
			{
				// process message
				var states:Vector.<WebSocketState> = WebSocket.processMessage(this._buffer, position);
				
				// only attempt reading if we have been able to parse a state, otherwise we want to wait
				// for more data to arrive, and then reprocess the whole buffer. this way messages
				// can be split over multiple packets
				if (states.length > 0)
				{
					var readPosition:int = 0;
					
					for (var i:int = 0; i < states.length; i++)
					{
						var state:WebSocketState = states[i];
						
						switch (state.state)
						{
							case WebSocketState.STATE_MESSAGE_ERROR:
								this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Data must start with \\x00"));
								break;
							case WebSocketState.STATE_MESSAGE_RECEIVED:
								this.dispatchEvent(new WebSocketEvent(WebSocketEvent.MESSAGE, "Received data packet successfully", state.data));
								break;
							case WebSocketState.STATE_MESSAGE_CLOSE:
								this.close();
								break;
						}
						
						if (states[i].position > readPosition)
						{
							readPosition = state.position;
						}
					}
					
					UtilKit.logger.info("WebSocket - Buffer clean requested on "+this._buffer.length+", removing from "+readPosition);
					
					// remove the processed data from the buffer
					this._buffer = WebSocket.removeBufferBefore(this._buffer, readPosition);
					
					UtilKit.logger.info("WebSocket - Buffer cleaned to "+this._buffer.length+"");
				}
			}
		}
		
		protected function findOrigin():void
		{
			if (ExternalInterface.available)
			{
				try
				{
					this._origin = ExternalInterface.call("window.location.href.toString");
				}
				catch (e:Error)
				{
					this._origin = null;
				}
			}
			
			if (this._origin == null)
			{
				var garbage:Object = { connection: new LocalConnection() };
				
				this._origin = garbage.connection.domain;
				
				delete garbage.connection;
				garbage = null;
			}
			
			this._origin = this._origin.toLowerCase();
		}
		
		protected function onSocketIOError(e:IOErrorEvent):void
		{
			UtilKit.logger.error("IO error occurred on the Socket", e.text);
			
			this.close();
			
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "IO error occurred on the socket connection: "+ e.text));
		}
		
		protected function onSocketSecurityError(e:SecurityErrorEvent):void
		{
			UtilKit.logger.error("Security error occurred on the Socket");
			
			this.close();
			
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Security error occurred on the socket connection: "+ e.text));
		}
		
		public function get readyState():uint
		{
			return this._readyState;
		}
		
		public function get bufferedAmount():int
		{
			return this._bufferedAmount;
		}
		
		public function get url():String
		{
			return this._url;
		}
		
		public function get protocol():String
		{
			return this._protocol;
		}
		
		public function get hostname():String
		{
			return this._hostname;
		}
		
		public function get port():uint
		{
			return this._port;
		}
		
		public function get path():String
		{
			return this._path;
		}
		
		public function get origin():String
		{
			return this._origin;
		}
		
		public function get timeout():uint
		{
			return this._timeout;
		}
		
		public function set timeout(value:uint):void
		{
			this._timeout = value;
		}
		
		protected function get socket():Socket
		{
			BUILD::SSL
			{
				if (this.protocol == "wss")
				{
					return (this._secureSocket as Socket);
				}
			}
			
			return this._socket;
		}
		
		protected function writeData(data:*):void
		{
			var length:uint = 0;
			
			if (data is String)
			{
				this.socket.writeUTFBytes(data);
			}
			else if (data is ByteArray)
			{
				this.socket.writeBytes(data);
			}
		}
		
		public function send(data:*):int
		{
			if (this.readyState == WebSocket.OPEN)
			{
				//UtilKit.logger.debug("HEX: "+Hex.dumpBytes(data));
				
				var length:uint = data.length;

				UtilKit.logger.debug("WebSocket connection sent data, length of "+data.length);
								
				this.socket.writeByte(0x00);
				this.writeData(data);
				this.socket.writeByte(0xff);
				
				this.socket.flush();

				return -1;
			}
			else if (this.readyState == WebSocket.CLOSED)
			{
				var bytes:ByteArray = new ByteArray();
				//bytes.writeBytes(data);
				
				this.writeData(data);

				this._bufferedAmount += bytes.length;
				
				return this._bufferedAmount;
			}
			else
			{
				UtilKit.logger.error("WebSocket connection cannot send data, invalid state of '"+this.readyState+"'");
			
				return 0;
			}
		}
		
		public function close():void
		{
			UtilKit.logger.info("WebSocket has been asked to close");
			
			if (this.readyState != WebSocket.CLOSING && this.readyState != WebSocket.CLOSED)
			{
				this._readyState = WebSocket.CLOSING;

				if (this.socket != null)
				{
					try
					{
						BUILD::SSL
						{
							if (this._secureSocket != null)
							{
								this._secureSocket.close();
							}
						};
						
						this.socket.writeByte(0xff);
						this.socket.writeByte(0x00);
				
						this.socket.flush();
						this.socket.close();
					}
					catch (e:Error)
					{
						// ignore, sometimes the socket exists but can't be wrote to
					}
					finally
					{
						this._socket = null;
					}
				}
			}
		}
		
		private function initNoiseCharacters():void
		{
			this._noiseCharacters = new Vector.<String>();
			
			for (var i:int = 0x21; i <= 0x2f; ++i)
			{
				this._noiseCharacters.push(String.fromCharCode(i));
			}
			
			for (var j:int = 0x3a; j <= 0x7a; ++j)
			{
				this._noiseCharacters.push(String.fromCharCode(j));
			}
			
			UtilKit.logger.debug("Generated noise characters with "+this._noiseCharacters.length+" in the list");
		}
		
		private function generateKey():String
		{
			var spaces:uint = this.randomInt(1, 12);
			var maximum:uint = uint.MAX_VALUE / spaces;
			var number:uint = this.randomInt(0, maximum);
			var key:String = (number * spaces).toString();
			var noises:int = this.randomInt(1, 12);
			var position:int;
			
			for (var i:int = 0; i < noises; ++i)
			{
				var char:String = this._noiseCharacters[this.randomInt(0, this._noiseCharacters.length - 1)];
				
				position = this.randomInt(0, key.length);
				key = key.substr(0, position) + char + key.substr(position);
			}
			
			for (var j:int = 0; j < spaces; ++j)
			{
				position = this.randomInt(1, key.length - 1);
				key = key.substr(0, position) + " " + key.substr(position);
			}
			
			UtilKit.logger.debug("Generated WebSocket Key: "+key);
			
			return key;
		}
		
		private function generateKey3():String
		{
			var key:String = "";
			
			for (var i:int = 0; i < 8; ++i)
			{
				key += String.fromCharCode(this.randomInt(0, 255));
			}
			
			UtilKit.logger.debug("Generated WebSocket Key3: "+key);
			
			return key;
		}
		
		private function generateSecurityDigest(key1:String, key2:String, key3:String):String
		{
			var bytes1:String = this.keyToBytes(key1);
			var bytes2:String = this.keyToBytes(key2);
			
			return MD5.rstr_md5(bytes1 + bytes2 + key3);
		}
		
		private function keyToBytes(key:String):String
		{
			var keyNum:uint = parseInt(key.replace(/[^\d]/g, ""));
			var spaces:uint = 0;
			
			for (var i:int = 0; i < key.length; ++i)
			{
				if (key.charAt(i) == " ")
				{
					++spaces;
				}
			}
			
			var result:uint = keyNum / spaces;
			var bytes:String = "";
			
			for (var j:int = 3; j >= 0; --j)
			{
				bytes += String.fromCharCode((result >> (j * 8)) & 0xff);
			}
			
			return bytes;
		}
		
		private function randomInt(minimum:uint, maximum:uint):uint
		{
			return minimum + Math.floor(Math.random() * (Number(maximum) - minimum + 1));
		}
		
		private function writeBytes(bytes:String):void
		{
			for (var i:int = 0; i < bytes.length; i++)
			{
				this.socket.writeByte(bytes.charCodeAt(i));
			}
		}
		
		private function loadPolicyFile():void
		{
			var policyUrl:String = "xmlsocket://"+this.hostname+":80";
			
			UtilKit.logger.debug("Loading possible firewall safe policy file from: "+ policyUrl);
			
			Security.loadPolicyFile(policyUrl);
		}
		
		private function readBytes(buffer:ByteArray, count:int):String
		{
			var bytes:String = "";
			
			for (var i:int = 0; i < count; i++)
			{
				bytes += String.fromCharCode(buffer.readByte() & 0xff);
			}
			
			return bytes;
		}
		
		protected function processHeader(buffer:ByteArray, position:int):Vector.<WebSocketHeadState>
		{
			var states:Vector.<WebSocketHeadState> = new Vector.<WebSocketHeadState>();
			var offset:int = position;
			
			for (; offset < buffer.length; offset++)
			{
				if (this._headerState < 4)
				{
					if ((this._headerState == 0 || this._headerState == 2) && buffer[offset] == 0x0d)
					{
						this._headerState++;	
					}
					else if ((this._headerState == 1 || this._headerState == 3) && buffer[offset] == 0x0a)
					{
						this._headerState++;
					}
					else
					{
						this._headerState = 0;
					}
					
					if (this._headerState == 4)
					{
						buffer.position = 0;
						
						var header:String = this._buffer.readUTFBytes(offset + 1);
						
						UtilKit.logger.debug("WebSocket Response Header: \n"+header);
						
						var headStates:Vector.<WebSocketHeadState> = WebSocket.validateHeader(header);
						
						// validate header
						if (headStates.length > 0)
						{
							return headStates;	
						}
						
						buffer = WebSocket.removeBufferBefore(buffer, offset + 1);
						offset = -1;
						
						//this.removeBufferBefore(offset + 1);
						//offset = -1;
					}
				}
				else if (this._headerState == 4)
				{
					// or 15, if we remove the response header from the buffer before we look here
					if (offset == 15)
					{
						//this._buffer.position = 0;
						
						var responseDigest:String = this.readBytes(buffer, 16);
						
						UtilKit.logger.debug("Response digest: "+ responseDigest);
						
						if (responseDigest != this._expectedDigest)
						{
							//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Response digest '"+ responseDigest +"' does not match expected digest '"+ this._expectedDigest +"'"));
							states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, offset, "Response digest '"+ responseDigest +"' does not match expected digest '"+ this._expectedDigest +"'"));
							
							return states;
						}
						
						this._headerState = 5;
						
						buffer = WebSocket.removeBufferBefore(buffer, offset + 1);
						offset = -1;
						
						this._readyState = WebSocket.OPEN;
						
						states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_OPEN, offset, "Socket connection successfully opened and verified"));
						//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.OPEN, "Socket connection successfully opened and verified"));
						
						return states;
					}
				}
			}
			
			return states;
		}
		
		public static function processMessage(buffer:ByteArray, position:int):Vector.<WebSocketState>
		{
			var states:Vector.<WebSocketState> = new Vector.<WebSocketState>();
			var offset:int = 0;
			var firstBytePosition:int = -1;
			
			buffer.position = 0;
			
			for (; offset < buffer.length; offset++)
			{
				if (buffer[offset] == 0x00)
				{
					UtilKit.logger.info("Found 0x00 at "+offset);
					
					firstBytePosition = offset;
				}
				else if (buffer[offset] == 0xff && offset > 0)
				{		
					if (firstBytePosition == -1)
					{
						firstBytePosition = 0;
					}
					
					if (buffer[firstBytePosition] != 0x00) // firstBytePosition != -1 && 
					{
						UtilKit.logger.fatal("First byte of possible message packet is not 0x00 - corrupt. First byte position: "+firstBytePosition);
						
						// "Data must start with \\x00"
						states.push(new WebSocketState(WebSocketState.STATE_MESSAGE_ERROR, offset));
						
						// We dont break, as there might be a useful message after this lump of crap?
						continue;
					}
					
					// skip the first byte of the message
					buffer.position = firstBytePosition + 1;
					
					var data:ByteArray = new ByteArray();
					var length:int = (offset - firstBytePosition);
					
					UtilKit.logger.info("Reading message packet from "+firstBytePosition+" with a length of "+length);
					
					buffer.readBytes(data, 0, length);

					//"Received data packet successfully"
					states.push(new WebSocketState(WebSocketState.STATE_MESSAGE_RECEIVED, offset, data));
				}
				else if (offset == 1 && buffer[0] == 0xff && buffer[1] == 0x00)
				{
					UtilKit.logger.debug("Received closing data packet");
					
					states.push(new WebSocketState(WebSocketState.STATE_MESSAGE_CLOSE, offset));
					
					break;
				}
			}
			
			return states;
		}
		
		public static function validateHeader(header:String):Vector.<WebSocketHeadState>
		{
			var states:Vector.<WebSocketHeadState> = new Vector.<WebSocketHeadState>();
			var lines:Array = header.split(/\r\n/);
			
			if (!lines[0].match(/^HTTP\/1.1 101 /))
			{
				//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, ));
				states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Bad response received: "+lines[0]));
				
				return states;
			}
			
			var headers:Object = { };
			
			for (var i:int = 1; i < lines.length; i++)
			{
				if (lines[i].length == 0)
				{
					continue;
				}
				
				var match:Array = lines[i].match(/^(\S+): (.*)$/);
				
				if (!match)
				{
					//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Failed to parse response header at line: "+ lines[i]));
					states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Failed to parse response header at line: "+ lines[i]));
				}
				
				headers[match[1]] = match[2];
			}
			
			if (headers["Upgrade"] != "WebSocket")
			{
				//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Invalid upgrade requested: "+ headers["Upgrade"]));
				states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Invalid upgrade requested: "+ headers["Upgrade"]));
			}
			
			if (headers["Connection"] != "Upgrade")
			{
				//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Invalid connection requested: "+ headers["Connection"]));
				states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Invalid connection requested: "+ headers["Connection"]));
			}
			
			if (!headers["Sec-WebSocket-Origin"])
			{
				if (headers["WebSocket-Origin"])
				{
					//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "WebSocket server is using an older protocol revision, WebSocket-as3 requires WebSocket protocol 76 or later in the server"));
					states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "WebSocket server is using an older protocol revision, WebSocket requires WebSocket protocol 76 or later in the server"));
				}
				else
				{
					//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Header response missing Sec-WebSocket-Origin"));
					states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Header response missing Sec-WebSocket-Origin"));
				}
			}
			
			var origin:String = headers["Sec-WebSocket-Origin"].toString().toLowerCase();
			
			//if (origin != this.origin)
			//{
			//this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Origin from header '"+ origin +"' does not match request '"+ this.origin +"'"));
			//	states.push(new WebSocketHeadState(WebSocketState.STATE_HEAD_ERROR, -1, "Origin from header '"+ origin +"' does not match request '"+ this.origin +"'"));
			//}
			
			return states;
		}
		
		private static function removeBufferBefore(buffer:ByteArray, position:uint):ByteArray
		{			
			var nextBuffer:ByteArray = new ByteArray();

			if (position == 0)
			{
				return nextBuffer;
			}
			
			// read from the specified position into the new buffer
			buffer.position = position;
			buffer.readBytes(nextBuffer);
			
			nextBuffer.position = 0;
			
			// return new buffer (to swap with the old one)
			return nextBuffer;
		}
	}
}
