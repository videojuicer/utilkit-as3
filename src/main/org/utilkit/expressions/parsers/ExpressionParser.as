package org.utilkit.expressions.parsers
{
	import org.utilkit.constants.AlgebraicOperator;
	import org.utilkit.expressions.ExpressionContext;
	import org.utilkit.expressions.ExpressionParserConfiguration;

	public class ExpressionParser extends ExpressionContext
	{
		protected var _configuration:ExpressionParserConfiguration;

		public function ExpressionParser(configuration:ExpressionParserConfiguration = null)
		{
			if (configuration == null)
			{
				configuration = new ExpressionParserConfiguration();
			}
			
			this._configuration = configuration;
			
			super(null, 0);
		}
		
		public function get configuration():ExpressionParserConfiguration
		{
			return this._configuration;
		}
		
		public function get contextOpen():String
		{
			return this.configuration.contextOpen;
		}
		
		public function get contextClose():String
		{
			return this.configuration.contextClose;
		}
		
		public function get operators():Vector.<String>
		{
			return this.configuration.operators;
		}
		
		public override function get expressionParser():ExpressionParser
		{
			return this;
		}
		
		public function begin(tokenString:String):Vector.<Object>
		{
			this._tokenString = tokenString;
			
			var context:ExpressionContext = new ExpressionContext(this, 0);
			context.parse();
			
			return context.tokens;
		}
	}
}