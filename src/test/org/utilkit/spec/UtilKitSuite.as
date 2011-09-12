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
package org.utilkit.spec
{
	import org.utilkit.spec.tests.net.WebSocketTestCase;
	import org.utilkit.spec.tests.expressions.BooleanExpressionParserTestCase;
	import org.utilkit.spec.tests.expressions.ExpressionParserTestCase;
	import org.utilkit.spec.tests.expressions.MathematicalExpressionParserTestCase;
	import org.utilkit.spec.tests.util.TimeHelperTestCase;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class UtilKitSuite
	{
		// net
		public var websocketTest:WebSocketTestCase;
		
		// parser.expressions
		public var expressionParserTest:ExpressionParserTestCase;
		public var mathematicalExpressionParserTest:MathematicalExpressionParserTestCase;
		public var booleanExpressionParserTest:BooleanExpressionParserTestCase;
		
		// util
		public var timeHelperTest:TimeHelperTestCase;
	}
}
