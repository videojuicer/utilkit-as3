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
 * The Original Code is the UtilKit library.
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
package org.utilkit.expressions
{
	public class ExpressionFunction extends ExpressionContext
	{
		protected var _functionName:String = null;
		protected var _arguments:Vector.<Object>;
		
		public function ExpressionFunction(parentContext:ExpressionContext, parentStartPosition:int, functionName:String)
		{
			super(parentContext, parentStartPosition);
			
			this._functionName = functionName;
		}
		
		public function get functionName():String
		{
			return this._functionName;
		}
		
		public function get arguments():Vector.<Object>
		{
			return this._arguments;
		}
		
		public override function parse(contextOperators:Vector.<String> = null):void
		{
			var operators:Vector.<String> = new Vector.<String>();
			operators.push(",");
			
			super.parse(operators);
			
			this._arguments = new Vector.<Object>();
			
			for (var i:int = 0; i < this.tokens.length; i++)
			{
				var token:Object = this.tokens[i];
				
				if (token != ',')
				{
					this._arguments.push(token);
				}
			}
		}
	}
}
