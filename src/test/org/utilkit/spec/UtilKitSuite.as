package org.utilkit.spec
{
	import org.utilkit.spec.tests.net.WebSocketTestCase;
	import org.utilkit.spec.tests.parser.expressions.ExpressionParserTestCase;
	import org.utilkit.spec.tests.util.TimeHelperTestCase;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class UtilKitSuite
	{
		// net
		public var websocketTest:WebSocketTestCase;
		
		// parser.expressions
		public var expressionParserTest:ExpressionParserTestCase;
		
		// util
		public var timeHelperTest:TimeHelperTestCase;
	}
}