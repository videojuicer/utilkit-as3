package org.utilkit.spec.tests.expressions
{
	import flexunit.framework.Assert;
	
	import org.utilkit.constants.AlgebraicOperator;
	import org.utilkit.expressions.parsers.ExpressionParser;
	import org.utilkit.expressions.ExpressionParserConfiguration;
	import org.utilkit.expressions.InvalidExpressionException;

	public class ExpressionParserTestCase
	{
		protected var _parser:ExpressionParser;
		
		[Before]
		public function setUp():void
		{
			var operators:Array = [
				AlgebraicOperator.ARITHMETIC_ADD,
				AlgebraicOperator.ARITHMETIC_MINUS,
				AlgebraicOperator.ARITHMETIC_MULTIPLY,
				AlgebraicOperator.ARITHMETIC_DIVIDE 
			];
			
			this._parser = new ExpressionParser();
			this._parser.configuration.operatorsSource = operators;
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Tests a basic expression")]
		public function parsesBasicExpression():void
		{
			var expression:String = "5 + 5";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertTrue((results[0] is String));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			
			Assert.assertEquals(results[0], "5");
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "5");
		}
		
		[Test(description="Tests a more complex expression")]
		public function parsesComplexExpression():void
		{
			var expression:String = "2 + 2 * 2 + 2";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(7, results.length);
			
			Assert.assertTrue((results[0] is String));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			Assert.assertTrue((results[3] is String));
			Assert.assertTrue((results[4] is String));
			Assert.assertTrue((results[5] is String));
			Assert.assertTrue((results[6] is String));
			
			Assert.assertEquals(results[0], "2");
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "2");
			Assert.assertEquals(results[3], "*");
			Assert.assertEquals(results[4], "2");
			Assert.assertEquals(results[5], "+");
			Assert.assertEquals(results[6], "2");
		}
		
		[Test(description="Tests a basic expression with a single new context")]
		public function parsesExpressionWithContext():void
		{
			var expression:String = "(2 + 2) + 6";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as Vector.<Object>));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			
			Assert.assertEquals(results[0][0], "2");
			Assert.assertEquals(results[0][1], "+");
			Assert.assertEquals(results[0][2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "6");
		}
		
		[Test(description="Tests a basic expression with multiple contexts")]
		public function parsesExpressionWithMultipleContexts():void
		{
			var expression:String = "(2 + 3) + (2 + (1 + 2))";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as Vector.<Object>));
			Assert.assertTrue((results[1] is String));
			Assert.assertNotNull((results[2] as Vector.<Object>));
			
			Assert.assertEquals(results[0][0], "2");
			Assert.assertEquals(results[0][1], "+");
			Assert.assertEquals(results[0][2], "3");
			
			Assert.assertEquals(results[1], "+");
			
			Assert.assertNotNull((results[2][2] as Vector.<Object>));
			
			Assert.assertEquals(results[2][0], "2");
			Assert.assertEquals(results[2][1], "+");
			
			Assert.assertEquals(results[2][2][0], "1");
			Assert.assertEquals(results[2][2][1], "+");
			Assert.assertEquals(results[2][2][2], "2");
		}
		
		[Test(description="Tests a complex expression with multiple contexts")]
		public function parsesComplexExpressionWithMultipleContexts():void
		{
			var expression:String = "(2 + 2) * (2 + (1 + (1 + 5 + 3)))";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as Vector.<Object>));
			Assert.assertTrue((results[1] is String));
			Assert.assertNotNull((results[2] as Vector.<Object>));
			
			Assert.assertEquals(results[0][0], "2");
			Assert.assertEquals(results[0][1], "+");
			Assert.assertEquals(results[0][2], "2");
			
			Assert.assertEquals(results[1], "*");
						
			Assert.assertEquals(results[2][0], "2");
			Assert.assertEquals(results[2][1], "+");
			
			Assert.assertNotNull((results[2][2] as Vector.<Object>));
			
			Assert.assertEquals(results[2][2][0], "1");
			Assert.assertEquals(results[2][2][1], "+");
			
			Assert.assertNotNull((results[2][2][2] as Vector.<Object>));
			
			Assert.assertEquals(results[2][2][2][0], "1");
			Assert.assertEquals(results[2][2][2][1], "+");
			Assert.assertEquals(results[2][2][2][2], "5");
			Assert.assertEquals(results[2][2][2][3], "+");
			Assert.assertEquals(results[2][2][2][4], "3");
		}
		
		[Test(description="Tests that white spaces are skipped and dont end up in our results")]
		public function parsesExpressionsAndIgnoresWhiteSpace():void
		{
			var expression:String = "  (   2   +   2  )          +           6       ";
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as Vector.<Object>));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			
			Assert.assertEquals(results[0][0], "2");
			Assert.assertEquals(results[0][1], "+");
			Assert.assertEquals(results[0][2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "6");
		}
		
		[Test(description="Tests that an expression can end with an operator")]
		public function expressionsFailWhenEmptyAfterOperator():void
		{
			var expression:String = "5 +";
			
			var results:Vector.<Object> = this._parser.begin(expression);
			
			Assert.assertEquals(2, results.length);
			
			Assert.assertTrue((results[0] is String));
			Assert.assertTrue((results[1] is String));
			
			Assert.assertEquals(results[0], "5");
			Assert.assertEquals(results[1], "+");
		}
		
		[Test(description="Tests that an expression with a missing context operator fails to produce any results")]
		public function expressionsFailWhenMissingContextCatch():void
		{
			var expression:String = "(2 + 2 + 6";
			var results:Vector.<Object> = null;
			
			try
			{
				results = this._parser.begin(expression);
				
				Assert.fail("Parsed an invalid expression, exception failed to dispatch.");
			}
			catch (e:InvalidExpressionException)
			{
				Assert.assertNull(results);
			}
			catch (e:Error)
			{
				Assert.fail("Unknown exception caught");
			}
		}
	}
}