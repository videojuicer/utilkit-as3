package org.utilkit.expressions
{
	import org.utilkit.collection.Hashtable;

	public class ExpressionParserConfiguration
	{
		protected var _operators:Vector.<String>;
		
		protected var _contextOpen:String = null;
		protected var _contextClose:String = null;
		
		protected var _variables:Hashtable;
		protected var _functions:Hashtable;
		
		public function ExpressionParserConfiguration(operatorsSource:Array = null, contextOpen:String = '(', contextClose:String = ')')
		{
			this.operatorsSource = operatorsSource;
			
			this.contextOpen = contextOpen;
			this.contextClose = contextClose;
			
			this._variables = new Hashtable();
			this._functions = new Hashtable();
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
		
		public function get variables():Hashtable
		{
			return this._variables;
		}
		
		public function set variables(value:Hashtable):void
		{
			this._variables = value;
		}
		
		public function get functions():Hashtable
		{
			return this._functions;
		}
		
		public function set functions(value:Hashtable):void
		{
			this._functions = value;
		}
	}
}