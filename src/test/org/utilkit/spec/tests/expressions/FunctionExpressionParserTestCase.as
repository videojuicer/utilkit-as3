package org.utilkit.spec.tests.expressions
{
	import flexunit.framework.Assert;
	
	import org.utilkit.expressions.parsers.FunctionExpressionParser;

	public class FunctionExpressionParserTestCase
	{
		protected var _parser:FunctionExpressionParser;
		
		[Before]
		public function setUp():void
		{
			this._parser = new FunctionExpressionParser();
			
			this._parser.configuration.functions.setItem("helloWorld", this.helloWorld);
			this._parser.configuration.functions.setItem("playedCount", this.playedCount);
			this._parser.configuration.functions.setItem("sum", this.sum);
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		public function helloWorld():Number
		{
			return 100;
		}
		
		public function playedCount():Number
		{
			return 2;
		}
		
		public function sum(a:Number, b:Number):Number
		{
			return (a + b);
		}
		
		[Test(description="Tests a basic sum using one function")]
		public function calculatesBasicSumWithFunction():void
		{
			var expression:String = "helloWorld() + 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(105, results);
			
			expression = "helloWorld() - 5";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(95, results);
		}
		
		[Test(description="Tests a basic sum using one function with arguments")]
		public function calculatesBasicSumWithFunctionWithArguments():void
		{
			var expression:String = "sum(50, 50) + 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(105, results);
			
			expression = "sum(50, 50) - 5";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(95, results);
		}
		
		[Test(description="Tests a basic sum using a few functiosn")]
		public function calculatesBasicSumWithFunctions():void
		{
			var expression:String = "helloWorld() + (playedCount() + 3)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(105, results);
			
			expression = "helloWorld() - playedCount()";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(98, results);
		}
	}
}