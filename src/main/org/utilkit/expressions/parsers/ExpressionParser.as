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
		
		public function begin(tokenString:String):ExpressionContext
		{
			if (tokenString == null)
			{
				return null;
			}
			
			this._tokenString = tokenString;
			
			var context:ExpressionContext = new ExpressionContext(this, 0);
			
			context.parse();
			
			return context;
		}
	}
}
