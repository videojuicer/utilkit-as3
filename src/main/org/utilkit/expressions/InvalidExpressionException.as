package org.utilkit.expressions
{
	import flash.errors.IllegalOperationError;
	
	public class InvalidExpressionException extends IllegalOperationError
	{
		public static const TYPE_MISSING_CONTEXT_CLOSE:String = "typeMissingContextClose";
		
		protected var _exceptionType:String;
		
		public function InvalidExpressionException(type:String)
		{
			this._exceptionType = type;
			
			super("Invalid expression, could not continue parsing encounted error: "+this.exceptionType, 0);
		}
		
		public function get exceptionType():String
		{
			return this._exceptionType;
		}
	}
}