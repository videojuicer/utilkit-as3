package org.utilkit.logger.renderers
{
	import flash.errors.IllegalOperationError;
	
	import org.utilkit.logger.LogMessage;

	public class LogRenderer
	{
		public function LogRenderer()
		{
			
		}
		
		public function render(message:LogMessage):void
		{
			throw new IllegalOperationError("Render must be overridden by the parent LogRenderer.");
		}
	}
}