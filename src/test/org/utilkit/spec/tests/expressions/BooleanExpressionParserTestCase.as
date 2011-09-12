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
	
	import org.utilkit.expressions.parsers.BooleanExpressionParser;
	import org.utilkit.expressions.InvalidExpressionException;
	
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
