package org.utilkit.expressions.parsers
{
	public class FunctionExpressionParser extends AlgebraicExpressionParser
	{
		public function FunctionExpressionParser()
		{
			super();
		}
		
		public override function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			// switch, previous + current for the function result
			if (this.configuration.functions.hasItem(previous))
			{
				var previousFunc:Function = this.configuration.functions.getItem(previous);
				
				previous = previousFunc.call();
			}
			
			if (this.configuration.functions.hasItem(current))
			{
				var currentFunc:Function = this.configuration.functions.getItem(current);
				
				current = currentFunc.call();
			}
			
			return super.calculateSum(previous, operator, current);
		}
	}
}