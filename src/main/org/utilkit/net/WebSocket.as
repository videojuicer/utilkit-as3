package org.utilkit.net
{
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
		
		protected var _expectedDigest:String;
		protected var _buffer:ByteArray;
		protected var _dataQueue:Vector.<ByteArray>;
		
		protected var _socket:Socket;
		
		protected var _readyState:uint = WebSocket.CONNECTING;
		protected var _headerState:uint = WebSocket.CONNECTING;
		protected var _bufferedAmount:int = WebSocket.CONNECTING;
		
		private var _noiseCharacters:Vector.<String>;
		
		// ready states
		public static const CONNECTING:uint = 0;
		public static const OPEN:uint = 1;
		public static const CLOSING:uint = 2;
		public static const CLOSED:uint = 3;
		
		public function WebSocket(url:String, protocols:Vector.<String> = null)
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
			
			if (this.protocol.toLowerCase() != "ws")
			{
				throw new IllegalOperationError(this.protocol+" protocol not supported.");
				
				return;
			}
			
			this.initNoiseCharacters();
			this.findOrigin();
		}
			
		public function connect():void
		{
			this.loadPolicyFile();

			this._socket = new Socket();
			this._buffer = new ByteArray();
			this._dataQueue = new Vector.<ByteArray>();
			
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
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
			
			this._socket.writeUTFBytes(header);
			
			UtilKit.logger.debug("Sending Key3: "+key3);
			
			this.writeBytes(key3);

			this._socket.flush();
		}
		
		protected function onSocketClose(e:Event):void
		{
			this._readyState = WebSocket.CLOSED;

			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.CLOSE, "Connection closed"));
		}
		
		protected function onSocketData(e:ProgressEvent):void
		{
			var position:int = this._buffer.length;
		
			UtilKit.logger.info("Received socket data from position: "+position);
			
			this._socket.readBytes(this._buffer, position);
			
			for (; position < this._buffer.length; position++)
			{
				if (this._headerState < 4)
				{
					if ((this._headerState == 0 || this._headerState == 2) && this._buffer[position] == 0x0d)
					{
						this._headerState++;	
					}
					else if ((this._headerState == 1 || this._headerState == 3) && this._buffer[position] == 0x0a)
					{
						this._headerState++;
					}
					else
					{
						this._headerState = 0;
					}
					
					if (this._headerState == 4)
					{
						this._buffer.position = 0;
						
						var header:String = this._buffer.readUTFBytes(position + 1);
						
						UtilKit.logger.debug("WebSocket Response Header: \n"+header);
						
						// validate header
						if (!this.validateHeader(header))
						{
							return;	
						}
						
						this.removeBufferBefore(position + 1);
						position = -1;
					}
				}
				else if (this._headerState == 4)
				{
					if (position == 15)
					{
						this._buffer.position = 0;
						
						var responseDigest:String = this.readBytes(this._buffer, 16);
						
						UtilKit.logger.debug("Response digest: "+ responseDigest);
						
						if (responseDigest != this._expectedDigest)
						{
							this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Response digest '"+ responseDigest +"' does not match expected digest '"+ this._expectedDigest +"'"));
							
							return;
						}
						
						this._headerState = 5;
						this.removeBufferBefore(position + 1);
						
						position = -1;
						
						this._readyState = WebSocket.OPEN;
						
						this.dispatchEvent(new WebSocketEvent(WebSocketEvent.OPEN, "Socket connection successfully opened and verified"));
					}
				}
				else
				{
					if (this._buffer[position] == 0xff && position > 0)
					{
						if (this._buffer[0] != 0x00)
						{
							this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Data must start with \\x00"));
							
							return;
						}
						
						this._buffer.position = 1;
						
						var data:ByteArray = new ByteArray();
						
						this._buffer.readBytes(data, 0, position - 1);
						// .readUTFBytes(position - 1);
						
						// were not just passing to JS and back so we dont want to encode the data
						//data = encodeURIComponent(data);
						
						UtilKit.logger.debug("Received data packet: "+ data);
						
						this._dataQueue.push(data);
						
						var obj:* = data.readObject();
						
						this.dispatchEvent(new WebSocketEvent(WebSocketEvent.MESSAGE, "Received data packet successfully", data));
						
						this.removeBufferBefore(position + 1);
						
						position = -1;
					}
					else if (position == 1 && this._buffer[0] == 0xff && this._buffer[1] == 0x00)
					{
						UtilKit.logger.debug("Received closing data packet");
						
						this.removeBufferBefore(position + 1);
						
						position = -1;
						
						this.close();
					}
				}
			}
		}
		
		protected function validateHeader(header:String):Boolean
		{
			var lines:Array = header.split(/\r\n/);
			
			if (!lines[0].match(/^HTTP\/1.1 101 /))
			{
				this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Bad response received: "+lines[0]));
				
				return false;
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
					this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Failed to parse response header at line: "+ lines[i]));
					
					return false;
				}
				
				headers[match[1]] = match[2];
			}
			
			if (headers["Upgrade"] != "WebSocket")
			{
				this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Invalid upgrade requested: "+ headers["Upgrade"]));
				
				return false;
			}
			
			if (headers["Connection"] != "Upgrade")
			{
				this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Invalid connection requested: "+ headers["Connection"]));
				
				return false;
			}
			
			if (!headers["Sec-WebSocket-Origin"])
			{
				if (headers["WebSocket-Origin"])
				{
					this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "WebSocket server is using an older protocol revision, WebSocket-as3 requires WebSocket protocol 76 or later in the server"));
				}
				else
				{
					this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Header response missing Sec-WebSocket-Origin"));
				}
				
				return false;
			}
			
			var origin:String = headers["Sec-WebSocket-Origin"].toString().toLowerCase();
			
			if (origin != this.origin)
			{
				this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Origin from header '"+ origin +"' does not match request '"+ this.origin +"'"));
				
				return false;
			}
			
			return true;
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
			UtilKit.logger.error("IO error occured on the Socket", e.text);
			
			this.close();
			
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "IO error occured on the socket connection: "+ e.text));
		}
		
		protected function onSocketSecurityError(e:SecurityErrorEvent):void
		{
			UtilKit.logger.error("Security error occured on the Socket");
			
			this.close();
			
			this.dispatchEvent(new WebSocketEvent(WebSocketEvent.ERROR, "Security error occured on the socket connection: "+ e.text));
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
		
		protected function writeData(data:*):void
		{
			var length:uint = 0;
			
			if (data is String)
			{
				this._socket.writeUTFBytes(data);
			}
			else if (data is ByteArray)
			{
				this._socket.writeBytes(data);
			}
		}
		
		public function send(data:*):int
		{
			if (this.readyState == WebSocket.OPEN)
			{
				//UtilKit.logger.debug("HEX: "+Hex.dumpBytes(data));
				
				var length:uint = data.length;
				
				/*var head:ByteArray = new ByteArray();
				head.endian = Endian.BIG_ENDIAN;
				head.writeByte(0x00);
				head.writeByte(0x00);
				head.writeByte(0x00);
				head.writeByte(0x00);
				head.writeByte((length & 0xFF000000));
				head.writeByte((length & 0x00FF0000));
				head.writeByte((length & 0x0000FF00));
				head.writeByte((length & 0x000000FF));*/
				
				UtilKit.logger.debug("WebSocket connection sent data, length of "+data.length+": "+data.toString());
								
				this._socket.writeByte(0x00);
				//this._socket.writeBytes(head);
				
				this.writeData(data);
				
				//._socket.writeBytes(data);
				this._socket.writeByte(0xff);
				
				this._socket.flush();

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

				this._socket.writeByte(0xff);
				this._socket.writeByte(0x00);
				
				this._socket.flush();
				this._socket.close();
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
		
		private function removeBufferBefore(position:uint):void
		{
			if (position == 0)
			{
				return;
			}
			
			var nextBuffer:ByteArray = new ByteArray();
			
			// read from the specified position into the new buffer
			this._buffer.position = position;
			this._buffer.readBytes(nextBuffer);
			
			// swap buffers
			this._buffer = nextBuffer;
		}
		
		private function randomInt(minimum:uint, maximum:uint):uint
		{
			return minimum + Math.floor(Math.random() * (Number(maximum) - minimum + 1));
		}
		
		private function writeBytes(bytes:String):void
		{
			for (var i:int = 0; i < bytes.length; i++)
			{
				this._socket.writeByte(bytes.charCodeAt(i));
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
	}
}