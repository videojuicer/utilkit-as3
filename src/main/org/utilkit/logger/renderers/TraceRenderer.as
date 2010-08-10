package org.utilkit.logger.renderers
{
	import org.utilkit.logger.LogMessage;

	public class TraceRenderer extends LogRenderer
	{
		public function TraceRenderer()
		{
			super();
		}
		
		public override function render(message:LogMessage):void
		{
			trace(message.toString());
		}
	}
}