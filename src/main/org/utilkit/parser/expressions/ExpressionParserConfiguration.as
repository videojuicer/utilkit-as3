package org.utilkit.parser.expressions
{
	public class ExpressionParserConfiguration
	{
		protected var _operators:Vector.<String>;
		
		protected var _contextOpen:String = null;
		protected var _contextClose:String = null;
		
		public function ExpressionParserConfiguration(operatorsSource:Array = null, contextOpen:String = '(', contextClose:String = ')')
		{
			this.operatorsSource = operatorsSource;
			
			this.contextOpen = contextOpen;
			this.contextClose = contextClose;
		}
		
		public function get operators():Vector.<String>
		{
			return this._operators;
		}
		
		public function set operators(value:Vector.<String>):void
		{
			this._operators = value;
		}
		
		public function set operatorsSource(value:Array):void
		{
			this.operators = new Vector.<String>();
			
			if (value == null)
			{
				return;
			}
			
			for (var i:int = 0; i < value.length; i++)
			{
				this.operators.push(value[i]);
			}
		}
		
		public function get contextOpen():String
		{
			return this._contextOpen;
		}
		
		public function set contextOpen(value:String):void
		{
			this._contextOpen = value;
		}
		
		public function get contextClose():String
		{
			return this._contextClose;
		}
		
		public function set contextClose(value:String):void
		{
			this._contextClose = value;
		}
	}
}