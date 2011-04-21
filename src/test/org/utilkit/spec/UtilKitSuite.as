package org.utilkit.spec
{
	import org.utilkit.spec.tests.net.WebSocketTestCase;
	import org.utilkit.spec.tests.parser.expressions.BooleanExpressionParserTestCase;
	import org.utilkit.spec.tests.parser.expressions.ExpressionParserTestCase;
	import org.utilkit.spec.tests.parser.expressions.MathematicalExpressionParserTestCase;
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