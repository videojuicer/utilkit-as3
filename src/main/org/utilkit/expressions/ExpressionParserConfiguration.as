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
	import org.utilkit.collection.Hashtable;

	public class ExpressionParserConfiguration
	{
		protected var _operators:Vector.<String>;
		
		protected var _contextOpen:String = null;
		protected var _contextClose:String = null;
		
		protected var _variables:Hashtable;
		protected var _functions:Hashtable;
		
		public function ExpressionParserConfiguration(operatorsSource:Array = null, contextOpen:String = '(', contextClose:String = ')')
		{
			this.operatorsSource = operatorsSource;
			
			this.contextOpen = contextOpen;
			this.contextClose = contextClose;
			
			this._variables = new Hashtable();
			this._functions = new Hashtable();
		}
		
		public function get operators():Vector.<String>
		{
			return this._operators;
		}
		
		public function set operators(value:Vector.<String>):void
		{
			this._operators = value;
		}
		
		public function set operatorsSource(value:Array):void
		{
			this.operators = new Vector.<String>();
			
			if (value == null)
			{
				return;
			}
			
			for (var i:int = 0; i < value.length; i++)
			{
				this.operators.push(value[i]);
			}
		}
		
		public function get contextOpen():String
		{
			return this._contextOpen;
		}
		
		public function set contextOpen(value:String):void
		{
			this._contextOpen = value;
		}
		
		public function get contextClose():String
		{
			return this._contextClose;
		}
		
		public function set contextClose(value:String):void
		{
			this._contextClose = value;
		}
		
		public function get variables():Hashtable
		{
			return this._variables;
		}
		
		public function set variables(value:Hashtable):void
		{
			this._variables = value;
		}
		
		public function get functions():Hashtable
		{
			return this._functions;
		}
		
		public function set functions(value:Hashtable):void
		{
			this._functions = value;
		}
		
		public function matchesDeclaration(token:String, character:String):Boolean
		{
			if (token.length >= 3)
			{
				for (var i:int = 0; i < this.functions.length; i++)
				{
					var method:String = (this.functions.getKeyAt(i) as String);
					
					if (method.substr(0, token.length) == token)
					{
						if (method.substr(0, (token.length + 1)) == token.concat(character))
						{
							return true;
						}
					}
				}
				
				for (var j:int = 0; j < this.variables.length; j++)
				{
					var variable:String = (this.variables.getKeyAt(j) as String);
				
					if (variable.substr(0, token.length) == token)
					{
						//return true;
					}
				}
			}
			
			return false;
		}
	}
}
