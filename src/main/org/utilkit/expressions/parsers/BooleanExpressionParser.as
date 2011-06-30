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
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_GREATER_THAN);
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_LESS_THAN);
			
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_NOT_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_GREATER_THAN);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_LESS_THAN);
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
				
				switch (operator)
				{
					case AlgebraicOperator.RELATIONAL_EQUALS:
					case AlgebraicOperator.HUMAN_RELATIONAL_EQUALS:
						result = (previous == current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_NOT_EQUALS:
					case AlgebraicOperator.HUMAN_RELATIONAL_NOT_EQUALS:
						result = (previous != current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_GREATER_THAN:
					case AlgebraicOperator.HUMAN_RELATIONAL_GREATER_THAN:
						result = (current > previous ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_LESS_THAN:
					case AlgebraicOperator.HUMAN_RELATIONAL_LESS_THAN:
						result = (current < previous ? 1 : 0);
						break;
				}
			}
			
			return result;
		}
	}
}