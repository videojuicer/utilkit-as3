package org.utilkit.expressions.parsers
{
	import org.utilkit.constants.AlgebraicOperator;
	import org.utilkit.expressions.ExpressionParserConfiguration;
	import org.utilkit.util.NumberHelper;

	public class MathematicalExpressionParser
	{
		protected var _expressionParser:ExpressionParser;
		
		protected var _tokens:Vector.<Object>;
		protected var _tokenString:String = null;
		
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
			return this.evaluate(tokenString);
		}
		
		public function evaluate(tokenString:String):Number
		{
			if (tokenString == null)
			{
				return NaN;
			}
			
			if (this._tokenString != tokenString || this._tokens == null || this._tokens.length == 0)
			{
				this._tokens = this._expressionParser.begin(tokenString).toVector();
			}
			
			return this.parse(this._tokens);
		}
		
		public function parse(context:Vector.<Object>):Number
		{
			var result:Number = NaN;
			var previous:Object = null;
			var operator:String = null;
			var usedOperator:Boolean = true;
			
			for (var i:int = 0; i < context.length; i++)
			{
				var token:Object = context[i];
				
				if (token is Vector.<Object>)
				{
					var child:Number = this.parse((token as Vector.<Object>));
					
					// set the token to our context result, so we use it with the previous
					token = child;
				}
				else if (this.declaredAndAvailable(token))
				{
					
				}
				else
				{
					var operatorFound:Boolean = false;
					
					for (var k:int = 0; k < this._expressionParser.operators.length; k++)
					{
						var op:String = this._expressionParser.operators[k];
						
						if (token == op)
						{
							operatorFound = true;
							usedOperator = false;
							
							operator = op;
							
							break;
						}
					}
					
					if (operatorFound)
					{
						operatorFound = false;
						
						
						continue;
					}
				}
				
				if (previous != null)
				{
					token = this.calculateValue(token);
					result = this.calculateSum(previous, operator, token);
					
					usedOperator = true;
					
					// now we have calculated the sum, our previous is the result
					// so the next loop around will use the result
					previous = result;
				}
				else
				{
					if (!usedOperator)
					{
						token = operator + token;
						
						usedOperator = true;
					}
					
					previous = this.calculateValue(token);
				}
			}
			
			if (previous != null && context.length == 1)
			{
				var previousResult:Number = new Number(previous);
				
				if (!isNaN(previousResult))
				{
					result = previousResult;
				}
			}
			
			if (isNaN(result) && previous != null)
			{
				result = this.calculateSum(previous, operator, null);
			}
			
			return result;
		}
		
		public function declaredAndAvailable(value:Object):Boolean
		{
			return false;
		}
		
		public function calculateValue(value:Object):Object
		{
			return value;
		}
		
		public function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			var result:Number = NaN;
			
			if (operator == null)
			{
				operator = AlgebraicOperator.ARITHMETIC_ADD;
			}
			
			if (current == null)
			{
				current = 0;
			}
			
			var a:Number = new Number(previous.toString());
			var b:Number = new Number(current.toString());
			
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