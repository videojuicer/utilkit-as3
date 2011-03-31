package org.utilkit.spec
{
	import org.utilkit.spec.tests.net.WebSocketTestCase;
	import org.utilkit.spec.tests.util.TimeHelperTestCase;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class UtilKitSuite
	{
		public var websocketTest:WebSocketTestCase;
		public var timeHelperTest:TimeHelperTestCase;
	}
}