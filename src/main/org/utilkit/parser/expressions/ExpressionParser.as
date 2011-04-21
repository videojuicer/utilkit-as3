package org.utilkit.parser.expressions
{
	import org.utilkit.constants.AlgebraicOperator;

	public class ExpressionParser extends ExpressionContext
	{
		protected var _contextOpen:String = null;
		protected var _contextClosed:String = null;
		
		protected var _operators:Vector.<String>;

		public function ExpressionParser(operators:Array, contextOpen:String = '(', contextClosed:String = ')')
		{
			this._operators = new Vector.<String>();
			
			for (var i:int = 0; i < operators.length; i++)
			{
				this._operators.push(operators[i]);
			}
			
			this._contextOpen = contextOpen;
			this._contextClosed = contextClosed;
			
			super(null, 0);
		}
		
		public function get contextOpen():String
		{
			return this._contextOpen;
		}
		
		public function get contextClosed():String
		{
			return this._contextClosed;
		}
		
		public function get operators():Vector.<String>
		{
			return this._operators;
		}
		
		public override function get expressionParser():ExpressionParser
		{
			return this;
		}
		
		public function begin(tokenString:String):Vector.<Object>
		{
			this._tokenString = tokenString;
			
			var context:ExpressionContext = new ExpressionContext(this, 0);
			context.parse();
			
			return context.tokens;
		}
	}
}