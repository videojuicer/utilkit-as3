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
	
	import org.utilkit.expressions.parsers.AlgebraicExpressionParser;

	public class AlgebraicExpressionParserTestCase
	{
		protected var _parser:AlgebraicExpressionParser;
		
		[Before]
		public function setUp():void
		{
			this._parser = new AlgebraicExpressionParser();
			
			this._parser.configuration.variables.setItem("playedCount", 10);
			this._parser.configuration.variables.setItem("worldCount", 1);
		}
		
		[After]
		public function tearDown():void
		{
			this._parser = null;
		}
		
		[Test(description="Tests a basic sum using one variable")]
		public function calculatesBasicSumWithVariable():void
		{
			var expression:String = "playedCount + 5";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(15, results);
			
			expression = "playedCount - 5";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(5, results);
		}
		
		[Test(description="Tests a complex sum using multiple variables")]
		public function calculatesComplexSumWithVariables():void
		{
			var expression:String = "(playedCount + 5) - (worldCount * 10)";
			var results:Number = this._parser.begin(expression);
			
			Assert.assertEquals(5, results);
			
			expression = "(playedCount * 5) + (worldCount + 100)";
			results = this._parser.begin(expression);
			
			Assert.assertEquals(151, results);
		}
		
		[Test(description="Tests that an expression can use AND gates")]
		public function canHasAndGates():void
		{
			Assert.assertTrue(this._parser.begin("(100 == 100) && (5 != 10)"));
			Assert.assertTrue(this._parser.begin("(100 != 101) && (10 == 10)"));
				
			Assert.assertFalse(this._parser.begin("(100 == 101) && (10 == 10)"));
			Assert.assertFalse(this._parser.begin("(100 == 100) && (10 < 10)"));
		}
		
		[Test(description="Tests that an expression can use OR gates")]
		public function canHasOrGates():void
		{
			Assert.assertTrue(this._parser.begin("(100 == 100) || (5 < 10)"));
			Assert.assertTrue(this._parser.begin("(100 != 101) || (10 == 10)"));
			
			Assert.assertTrue(this._parser.begin("(100 == 101) || (10 == 10)"));
			Assert.assertTrue(this._parser.begin("(100 == 100) || (10 < 10)"));
			
			Assert.assertFalse(this._parser.begin("(100 == 101) && (10 != 10)"));
			Assert.assertFalse(this._parser.begin("(100 == 101) && (10 < 10)"));
		}
		
		[Test(description="Tests that an expression can use both gates")]
		public function canHasGates():void
		{
			Assert.assertTrue(this._parser.begin("((100 == 100) && (5 == 10)) || 1 == 1"));
			Assert.assertTrue(this._parser.begin("(100 != 101) && (10 == 10)"));
			
			Assert.assertFalse(this._parser.begin("(100 == 101) && (10 == 10) || (500 == 100 || 10 == 12))"));
			Assert.assertFalse(this._parser.begin("((100 == 100) && (10 < 10)) || (2 < 0)"));
		}
	}
}
