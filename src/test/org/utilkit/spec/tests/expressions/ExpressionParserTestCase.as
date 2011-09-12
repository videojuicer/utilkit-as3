/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 * 
 * The Original Code is the UtilKit library.
 * 
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 * 
 * ***** END LICENSE BLOCK ******/
package org.utilkit.spec.tests.expressions
{
	import flexunit.framework.Assert;
	
	import org.utilkit.constants.AlgebraicOperator;
	import org.utilkit.expressions.ExpressionContext;
	import org.utilkit.expressions.ExpressionFunction;
	import org.utilkit.expressions.ExpressionParserConfiguration;
	import org.utilkit.expressions.InvalidExpressionException;
	import org.utilkit.expressions.parsers.ExpressionParser;

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
		
		[Test(description="Tests a basic expression with a function")]
		public function parsesBasicExpressionWithFunction():void
		{
			var expression:String = "(2 + 2) + hello()";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is ExpressionFunction));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals((results[2] as ExpressionFunction).functionName, "hello");
		}
		
		[Test(description="Tests that a null expression doesnt parse")]
		public function nullExpressionsDontParse():void
		{
			var expression:String = null;

			Assert.assertNull(this._parser.begin(expression));
		}
		
		[Test(description="Tests a basic expression with a function including arguments")]
		public function parsesBasicExpressionWithFunctionArguments():void
		{
			var expression:String = "(2 + 2) + hello(5, 4, 6)";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is ExpressionFunction));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals((results[2] as ExpressionFunction).functionName, "hello");
			
			Assert.assertEquals((results[2] as ExpressionFunction).tokens.length, 5);
			Assert.assertEquals((results[2] as ExpressionFunction).arguments.length, 3);
			
			Assert.assertEquals((results[2] as ExpressionFunction).tokens[0], "5");
			Assert.assertEquals((results[2] as ExpressionFunction).tokens[1], ",");
			Assert.assertEquals((results[2] as ExpressionFunction).tokens[2], "4");
			Assert.assertEquals((results[2] as ExpressionFunction).tokens[3], ",");
			Assert.assertEquals((results[2] as ExpressionFunction).tokens[4], "6");

			Assert.assertEquals((results[2] as ExpressionFunction).arguments[0], "5");
			Assert.assertEquals((results[2] as ExpressionFunction).arguments[1], "4");
			Assert.assertEquals((results[2] as ExpressionFunction).arguments[2], "6");
		}
		
		[Test(description="Tests that an expression can be transformed into a flat Vector")]
		public function parsesIntoFlatVector():void
		{
			var expression:String = "(2 + 2) + 6";
			var results:Vector.<Object> = this._parser.begin(expression).toVector();
			
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
		
		[Test(description="Tests that an expression with functions can be transformed into a flat Vector")]
		public function parsesIntoFlatVectorWithFunctions():void
		{
			var expression:String = "(2 + 2) + hello(5, 4, 6)";
			var results:Vector.<Object> = this._parser.begin(expression).toVector();
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as Vector.<Object>));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is Object));
			
			Assert.assertEquals(results[0][0], "2");
			Assert.assertEquals(results[0][1], "+");
			Assert.assertEquals(results[0][2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2].name, "hello");
			
			Assert.assertEquals(results[2].arguments.length, 3);
			
			Assert.assertEquals(results[2].arguments[0], "5");
			Assert.assertEquals(results[2].arguments[1], "4");
			Assert.assertEquals(results[2].arguments[2], "6");
		}
		
		[Test(description="Tests a basic expression")]
		public function parsesBasicExpression():void
		{
			var expression:String = "5 + 5";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
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
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
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
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "6");
		}
		
		[Test(description="Tests a basic expression with multiple contexts")]
		public function parsesExpressionWithMultipleContexts():void
		{
			var expression:String = "(2 + 3) + (2 + (1 + 2))";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertNotNull((results[2] as ExpressionContext));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "3");
			
			Assert.assertEquals(results[1], "+");
			
			Assert.assertNotNull((results[2] as ExpressionContext).tokens[2]);
			
			Assert.assertEquals((results[2] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[2] as ExpressionContext).tokens[1], "+");
			
			Assert.assertEquals(((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[0], "1");
			Assert.assertEquals(((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals(((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2], "2");
		}
		
		[Test(description="Tests a complex expression with multiple contexts")]
		public function parsesComplexExpressionWithMultipleContexts():void
		{
			var expression:String = "(2 + 2) * (2 + (1 + (1 + 5 + 3)))";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertNotNull((results[2] as ExpressionContext));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "2");
			
			Assert.assertEquals(results[1], "*");
						
			Assert.assertEquals((results[2] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[2] as ExpressionContext).tokens[1], "+");
			
			Assert.assertNotNull(((results[2] as ExpressionContext).tokens[2] as ExpressionContext));
			
			Assert.assertEquals(((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[0], "1");
			Assert.assertEquals(((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[1], "+");
			
			Assert.assertNotNull((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext));
			
			Assert.assertEquals((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[0], "1");
			Assert.assertEquals((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2], "5");
			Assert.assertEquals((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[3], "+");
			Assert.assertEquals((((results[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[2] as ExpressionContext).tokens[4], "3");
		}
		
		[Test(description="Tests that white spaces are skipped and dont end up in our results")]
		public function parsesExpressionsAndIgnoresWhiteSpace():void
		{
			var expression:String = "  (   2   +   2  )          +           6       ";
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
			Assert.assertEquals(3, results.length);
			
			Assert.assertNotNull((results[0] as ExpressionContext));
			Assert.assertTrue((results[1] is String));
			Assert.assertTrue((results[2] is String));
			
			Assert.assertEquals((results[0] as ExpressionContext).tokens[0], "2");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[1], "+");
			Assert.assertEquals((results[0] as ExpressionContext).tokens[2], "2");
			
			Assert.assertEquals(results[1], "+");
			Assert.assertEquals(results[2], "6");
		}
		
		[Test(description="Tests that an expression can end with an operator")]
		public function expressionsFailWhenEmptyAfterOperator():void
		{
			var expression:String = "5 +";
			
			var results:Vector.<Object> = this._parser.begin(expression).tokens;
			
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
				results = this._parser.begin(expression).tokens;
				
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
