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
package org.utilkit.util
{
	public class VectorUtil
	{
		public static function vectorToArray(vector:Vector.<Object>):Array
		{
			var result:Array = new Array();
			
			for (var i:int = 0; i < vector.length; i++)
			{
				var child:Object = vector[i];
				
				if (child is Vector.<Object>)
				{
					result.push(VectorUtil.vectorToArray((child as Vector.<Object>)));
				}
				else
				{
					result.push(child);
				}
			}
			
			return result;
		}
		
		public static function sort(vector:Vector.<Object>, compareFunction:Function):void
		{
			if (vector.length < 2) return;
			
			var firstHalf : uint = Math.floor(vector.length / 2);
			var secondHalf : uint = vector.length - firstHalf;
			
			var arr1:Vector.<Object> = new Vector.<Object>();
			var arr2:Vector.<Object> = new Vector.<Object>();
			
			var i : uint = 0;
			
			for (i = 0; i < firstHalf; ++i)
			{
				arr1[i] = vector[i];
			}
			
			for (i = firstHalf; i < firstHalf + secondHalf; ++i)
			{
				arr2[i - firstHalf] = vector[i];
			}
			
			VectorUtil.sort(arr1, compareFunction);
			VectorUtil.sort(arr2, compareFunction);
			
			i = 0;
			
			var j : uint = 0;
			var k : uint = 0;
			
			while (arr1.length != j && arr2.length != k)
			{
				if (compareFunction(arr1[j], arr2[k]) != 1)
				{
					vector[i] = arr1[j];
					
					i++;
					j++;
				}
				else
				{
					vector[i] = arr2[k];
					
					i++;
					k++;
				}
			}
			
			while (arr1.length != j)
			{
				vector[i] = arr1[j];
				
				i++;
				j++;
			}
			
			while (arr2.length != k)
			{
				vector[i] = arr2[k];
				
				i++;
				k++;
			}
		}
	}
}
