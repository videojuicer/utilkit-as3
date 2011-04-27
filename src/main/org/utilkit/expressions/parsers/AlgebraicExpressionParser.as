package org.utilkit.expressions.parsers
{
	public class AlgebraicExpressionParser extends BooleanExpressionParser
	{
		public function AlgebraicExpressionParser()
		{
			super();
		}
		
		public override function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			// switch, previous + current for the variable result
			if (this.configuration.variables.hasItem(previous))
			{
				previous = this.configuration.variables.getItem(previous);
			}
			
			if (this.configuration.variables.hasItem(current))
			{
				current = this.configuration.variables.getItem(current);
			}
			
			return super.calculateSum(previous, operator, current);
		}
	}
}