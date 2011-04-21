package org.utilkit.spec.tests.parser.expressions
{
	import flexunit.framework.Assert;
	
	import org.utilkit.parser.expressions.MathematicalExpressionParser;
	import org.utilkit.parser.expressions.InvalidExpressionException;
	
	public class MathematicalExpressionParserTestCase
	{
		protected var _parser:MathematicalExpressionParser;
		
		[Before]
		public function setUp():void
		{
			this._parser = new MathematicalExpressionParser();
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Tests a basic math sum using add")]
		public function calculatesBasicAddSum():void
		{
			var expression:String = "5 + 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(10, results);
		}
		
		[Test(description="Tests a basic math sum using minus")]
		public function calculatesBasicMinusSum():void
		{
			var expression:String = "5 - 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
		}
		
		[Test(description="Tests a basic math sum using multiply")]
		public function calculatesBasicMultiplySum():void
		{
			var expression:String = "5 * 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(25, results);
		}
		
		[Test(description="Tests a basic math sum using divide")]
		public function calculatesBasicDivideSum():void
		{
			var expression:String = "5 / 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
		
		[Test(description="Tests a more complex math sum using add")]
		public function calculatesComplexAddSum():void
		{
			var expression:String = "(5 + 5) + (5 + 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(20, results);
		}
		
		[Test(description="Tests a more complex math sum using minus")]
		public function calculatesComplexMinusSum():void
		{
			var expression:String = "(5 - 5) - (5 - 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
		}
		
		[Test(description="Tests a more complex math sum using multiply")]
		public function calculatesComplexMultiplySum():void
		{
			var expression:String = "(5 * 5) * (5 * 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(625, results);
		}
		
		[Test(description="Tests a more complex math sum using divide")]
		public function calculatesComplexDivideSum():void
		{
			var expression:String = "(5 / 5) / (5 / 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
		
		[Test(description="Tests a more complex math sum using multiple operators")]
		public function calculatesComplexSumUsingManyOperators():void
		{
			var expression:String = "(5 + 5) / (5 * 5)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0.4, results);
		}
	}
}