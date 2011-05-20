package mx.core
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class MovieClipLoaderAsset extends MovieClip
	{
		protected var _loader:Loader = null;
		protected var _initialized:Boolean = false;
		
		protected var _requestedWidth:Number;
		protected var _requestedHeight:Number;
		
		protected var initialWidth:Number = 0;
		protected var initialHeight:Number = 0;
		
		public function MovieClipLoaderAsset()
		{
			super();
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			if (context.hasOwnProperty("allowCodeImport"))
			{
				context["allowCodeImport"] = false;
			}
			
			this._loader = new Loader();
			
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoaderComplete);
			
			this._loader.loadBytes(this.movieClipData, context);
			
			this.addChild(this._loader);
		}
		
		public function get movieClipData():ByteArray
		{
			return null;
		}
		
		public override function get width():Number
		{
			if (this._initialized)
			{
				return this.initialWidth;
			}
			
			return super.width;
		}
		
		public override function set width(value:Number):void
		{
			if (!this._initialized)
			{
				this._requestedWidth = value;
			}
			else
			{
				this._loader.width = value;
			}
		}
		
		public override function get height():Number
		{
			if (this._initialized)
			{
				return this.initialHeight;
			}
			
			return super.height;
		}
		
		public override function set height(value:Number):void
		{
			if (!this._initialized)
			{
				this._requestedHeight = value;
			}
			else
			{
				this._loader.height = value;
			}
		}
		
		protected function onLoaderComplete(e:Event):void
		{
			this._initialized = true;
			
			this.initialWidth = this._loader.width;
			this.initialHeight = this._loader.height;
			
			if (!isNaN(this._requestedWidth))
			{
				this._loader.width = this._requestedWidth;
			}
			
			if (!isNaN(this._requestedHeight))
			{
				this._loader.height = this._requestedHeight;
			}
			
			this.dispatchEvent(e);
		}
	}
}