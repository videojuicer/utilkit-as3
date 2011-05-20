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
	}
}