package org.utilkit.expressions.parsers
{
	import org.utilkit.constants.AlgebraicOperator;

	public class BooleanExpressionParser extends MathematicalExpressionParser
	{
		public function BooleanExpressionParser()
		{
			super();
			
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_NOT_EQUALS);
		}
		
		public override function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			var result:Number = super.calculateSum(previous, operator, current);
			
			if (isNaN(result))
			{
				if (operator == AlgebraicOperator.RELATIONAL_EQUALS)
				{
					result = (previous == current ? 1 : 0);
				}
				else if (operator == AlgebraicOperator.RELATIONAL_NOT_EQUALS)
				{
					result = (previous != current ? 1 : 0);
				}
			}
			
			return result;
		}
	}
}