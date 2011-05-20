package org.utilkit.expressions.parsers
{
	public class AlgebraicExpressionParser extends BooleanExpressionParser
	{
		public function AlgebraicExpressionParser()
		{
			super();
		}
		
		public override function calculateValue(value:Object):Object
		{
			if (this.configuration.variables.hasItem(value))
			{
				return this.configuration.variables.getItem(value);
			}
			
			return super.calculateValue(value);
		}
	}
}