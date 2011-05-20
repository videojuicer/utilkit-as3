package org.utilkit.expressions.parsers
{
	import org.utilkit.util.VectorUtil;

	public class FunctionExpressionParser extends AlgebraicExpressionParser
	{
		public function FunctionExpressionParser()
		{
			super();
		}
		
		public override function calculateValue(value:Object):Object
		{
			if (value is Object && value.hasOwnProperty("name"))
			{
				var functionName:String = value.name;
				var functionArguments:Vector.<Object> = value.arguments;
				
				// switch, previous + current for the function result
				if (this.configuration.functions.hasItem(functionName))
				{
					var func:Function = this.configuration.functions.getItem(functionName);
					
					return func.apply(null, VectorUtil.vectorToArray(functionArguments));
				}
			}
			
			return super.calculateValue(value);
		}
	}
}