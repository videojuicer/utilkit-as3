package org.utilkit.parser.expressions
{
	import org.utilkit.constants.AlgebraicOperator;
	import org.utilkit.util.NumberHelper;

	public class MathematicalExpressionParser
	{
		protected var _expressionParser:ExpressionParser;
		
		public function MathematicalExpressionParser()
		{
			var configuration:ExpressionParserConfiguration = new ExpressionParserConfiguration();
			
			var operators:Array = [
				AlgebraicOperator.ARITHMETIC_ADD,
				AlgebraicOperator.ARITHMETIC_DIVIDE,
				AlgebraicOperator.ARITHMETIC_MINUS,
				AlgebraicOperator.ARITHMETIC_MULTIPLY
			];
			
			// override the operators so that we only use mathetical ones
			configuration.operatorsSource = operators;
			
			this._expressionParser = new ExpressionParser(configuration);
		}
		
		public function get configuration():ExpressionParserConfiguration
		{
			return this._expressionParser.configuration;
		}
		
		public function begin(tokenString:String):Number
		{
			var tokens:Vector.<Object> = this._expressionParser.begin(tokenString);
			var result:Number = this.parse(tokens);
			
			return result;
		}
		
		public function parse(context:Vector.<Object>):Number
		{
			var result:Number = 0;
			var operator:String = null;
			
			for (var i:int = 0; i < context.length; i++)
			{
				var token:Object = context[i];
				
				if (token is Vector.<Object>)
				{
					var child:Number = this.parse((token as Vector.<Object>));
					
					result = this.calculateSum(result, operator, child);
					
					continue;
				}
				
				var operatorFound:Boolean = false;
				
				for (var k:int = 0; k < this._expressionParser.operators.length; k++)
				{
					var op:String = this._expressionParser.operators[k];
					
					if (token == op)
					{
						operatorFound = true;
						operator = op;
						
						continue;
					}
				}
				
				if (operatorFound)
				{
					operatorFound = false;
					
					continue;
				}
				
				result = this.calculateSum((result.toString() as Object), operator, token);;
			}
			
			return result;
		}
		
		public function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			var result:Number = 0;
			
			if (operator == null)
			{
				operator = AlgebraicOperator.ARITHMETIC_ADD;
			}
			
			var a:Number = parseInt(previous.toString());
			var b:Number = parseInt(current.toString());
			
			if (isNaN(a) || isNaN(b))
			{
				return result;
			}
			
			switch (operator)
			{
				case AlgebraicOperator.ARITHMETIC_ADD:
					result = (a + b);
					break;
				case AlgebraicOperator.ARITHMETIC_DIVIDE:
					result = (a / b);
					break;
				case AlgebraicOperator.ARITHMETIC_MINUS:
					result = (a - b);
					break;
				case AlgebraicOperator.ARITHMETIC_MULTIPLY:
					result = (a * b);
					break;
				default:
					// unknown operator
					break;
			}
			
			return result;
		}
	}
}