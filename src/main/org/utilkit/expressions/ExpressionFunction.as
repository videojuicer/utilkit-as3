package org.utilkit.expressions
{
	public class ExpressionFunction extends ExpressionContext
	{
		protected var _functionName:String = null;
		protected var _arguments:Vector.<Object>;
		
		public function ExpressionFunction(parentContext:ExpressionContext, parentStartPosition:int, functionName:String)
		{
			super(parentContext, parentStartPosition);
			
			this._functionName = functionName;
		}
		
		public function get functionName():String
		{
			return this._functionName;
		}
		
		public function get arguments():Vector.<Object>
		{
			return this._arguments;
		}
		
		public override function parse(contextOperators:Vector.<String> = null):void
		{
			var operators:Vector.<String> = new Vector.<String>();
			operators.push(",");
			
			super.parse(operators);
			
			this._arguments = new Vector.<Object>();
			
			for (var i:int = 0; i < this.tokens.length; i++)
			{
				var token:Object = this.tokens[i];
				
				if (token != ',')
				{
					this._arguments.push(token);
				}
			}
		}
	}
}