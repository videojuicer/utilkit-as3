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
