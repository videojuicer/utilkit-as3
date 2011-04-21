package org.utilkit.parser.expressions
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
			
			if (result == 0)
			{
				switch (operator)
				{
					case AlgebraicOperator.RELATIONAL_EQUALS:
						result = (previous == current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_NOT_EQUALS:
						result = (previous != current ? 1 : 0);
						break;
				}
			}
			
			return result;
		}
	}
}