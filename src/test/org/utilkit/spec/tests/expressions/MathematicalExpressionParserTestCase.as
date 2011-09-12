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
 * The Original Code is the SMILKit library / StyleKit library / UtilKit library.
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
	
	import org.utilkit.expressions.parsers.MathematicalExpressionParser;
	import org.utilkit.expressions.InvalidExpressionException;
	
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
		
		[Test(description="Tests a basic math sum using add and floats")]
		public function calculatesBasicFloatingAddSum():void
		{
			var expression:String = "5.4 + 5.4";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(10.8, results);
		}
		
		[Test(description="Tests a basic math sum using minus")]
		public function calculatesBasicMinusSum():void
		{
			var expression:String = "5 - 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(0, results);
		}
		
		[Test(description="Tests a basic math sum using minus and floats")]
		public function calculatesBasicFloatingMinusSum():void
		{
			var expression:String = "5.0 - 5.0";
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
		
		[Test(description="Tests a basic math sum using multiply and floats")]
		public function calculatesBasicFloatingMultiplySum():void
		{
			var expression:String = "5.5 * 5.5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(30.25, results);
		}
		
		
		[Test(description="Tests a basic math sum using divide")]
		public function calculatesBasicDivideSum():void
		{
			var expression:String = "5 / 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(1, results);
		}
		
		[Test(description="Tests a basic math sum using divide and floats")]
		public function calculatesBasicFloatingDivideSum():void
		{
			var expression:String = "5.8 / 5.8";
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
		
		[Test(description="Tests a more complex math sum using add and floats")]
		public function calculatesComplexFloatingAddSum():void
		{
			var expression:String = "(5.4 + 5.4) + (5.8 + 5.8)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(22.4, results);
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
		
		[Test(description="Tests a more complex math sum using multiple operators and floats")]
		public function calculatesComplexFloatingSumUsingManyOperators():void
		{
			var expression:String = "(12.8 + 42.8) - (5.5 * 5.5))";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(25.349999999999994, results);
		}
	}
}
