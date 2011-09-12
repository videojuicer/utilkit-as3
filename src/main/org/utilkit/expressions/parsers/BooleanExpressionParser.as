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
package org.utilkit.expressions.parsers
{
	import org.utilkit.constants.AlgebraicOperator;

	public class BooleanExpressionParser extends MathematicalExpressionParser
	{
		public function BooleanExpressionParser()
		{
			super();
			
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_NOT_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_GREATER_THAN);
			this.configuration.operators.push(AlgebraicOperator.RELATIONAL_LESS_THAN);
			
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_NOT_EQUALS);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_GREATER_THAN);
			this.configuration.operators.push(AlgebraicOperator.HUMAN_RELATIONAL_LESS_THAN);
		
			this.configuration.operators.push(AlgebraicOperator.GATE_AND);
			this.configuration.operators.push(AlgebraicOperator.GATE_OR);
		}
		
		public override function calculateSum(previous:Object, operator:String, current:Object):Number
		{
			var result:Number = super.calculateSum(previous, operator, current);
			
			if (isNaN(result))
			{
				if (operator == AlgebraicOperator.RELATIONAL_EQUALS)
				{
					result = (previous == current ? 1 : 0);
				}
				else if (operator == AlgebraicOperator.RELATIONAL_NOT_EQUALS)
				{
					result = (previous != current ? 1 : 0);
				}
				
				switch (operator)
				{
					case AlgebraicOperator.RELATIONAL_EQUALS:
					case AlgebraicOperator.HUMAN_RELATIONAL_EQUALS:
						result = (previous == current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_NOT_EQUALS:
					case AlgebraicOperator.HUMAN_RELATIONAL_NOT_EQUALS:
						result = (previous != current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_GREATER_THAN:
					case AlgebraicOperator.HUMAN_RELATIONAL_GREATER_THAN:
						result = (previous > current ? 1 : 0);
						break;
					case AlgebraicOperator.RELATIONAL_LESS_THAN:
					case AlgebraicOperator.HUMAN_RELATIONAL_LESS_THAN:
						result = (previous < current ? 1 : 0);
						break;
					case AlgebraicOperator.GATE_AND:
						result = (previous && current ? 1 : 0);
						break;
					case AlgebraicOperator.GATE_OR:
						result = (previous || current ? 1 : 0);
						break;
				}
			}
			
			return result;
		}
	}
}
