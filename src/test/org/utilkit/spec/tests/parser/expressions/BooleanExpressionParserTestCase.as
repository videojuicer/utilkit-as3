package org.utilkit.spec.tests.parser.expressions
{
	import flexunit.framework.Assert;
	
	import org.utilkit.parser.expressions.BooleanExpressionParser;
	import org.utilkit.parser.expressions.InvalidExpressionException;
	
	public class BooleanExpressionParserTestCase
	{
		protected var _parser:BooleanExpressionParser;
		
		[Before]
		public function setUp():void
		{
			this._parser = new BooleanExpressionParser();
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Tests a basic equals boolean expression")]
		public function calculatesBasicEqualsBooleanExpression():void
		{
			var expression:String = "5 == 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
			
			expression = "5 == 10";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
		}
		
		[Test(description="Tests a basic not equals boolean expression")]
		public function calculatesBasicNotEqualsBooleanExpression():void
		{
			var expression:String = "5 != 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
			
			expression = "5 != 4";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
		
		[Test(description="Tests a more complex equals boolean expression")]
		public function calculatesComplexEqualsBooleanExpression():void
		{
			var expression:String = "(5 == 5) == (2 == (1 + 1))";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
			
			expression = "(5 == 4) == (2 == (1 + 1))";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
		}
		
		[Test(description="Tests a more complex not equals boolean expression")]
		public function calculatesComplexNotEqualsBooleanExpression():void
		{
			var expression:String = "(5 != 5) != (2 != (1 + 1))";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
			
			expression = "(5 != 5) != (2 != (3 + 1))";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
		
		[Test(description="Tests a more complex boolean expression using multiple operators")]
		public function calculatesComplexSumUsingManyOperators():void
		{
			var expression:String = "((27 * 5) != 4) == ((5 / 5) != 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
			
			expression = "((27 * 5) == 4) != ((5 / 5) == 5)";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
			
			expression = "(5 + 5) / (5 * 5) == 0.4";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
	}
}