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
package org.utilkit.spec.tests.util
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.utilkit.util.TimeHelper;
	
	public class TimeHelperTestCase
	{
		
		[Test(description="Ensures proper ms -> s conversion")]
		public function millisecondsToSecondsConverts():void
		{
			Assert.assertEquals(1, TimeHelper.millisecondsToSeconds(1000));
		}
		
		[Test(description="Ensures proper ms->m conversion")]
		public function millisecondsToMinutesConverts():void
		{
			Assert.assertEquals(1, TimeHelper.millisecondsToMinutes(60000));
			Assert.assertEquals(1, TimeHelper.millisecondsToMinutes(90000));
		}
		
		[Test(description="Ensures proper ms->h conversion")]
		public function millisecondsToHoursConverts():void
		{
			Assert.assertEquals(1, TimeHelper.millisecondsToHours(60000 * 60));
			Assert.assertEquals(1, TimeHelper.millisecondsToHours(90000 * 60));
		}
		
		[Test(description="Ensures wallclock values for times under an hour are rendered correctly")]
		public function smallWallClockValuesRendered():void
		{
			Assert.assertEquals("00:00", TimeHelper.millisecondsToWallclock(0));
			Assert.assertEquals("00:00", TimeHelper.millisecondsToWallclock(100));
			Assert.assertEquals("01:00", TimeHelper.millisecondsToWallclock(60020));
			Assert.assertEquals("01:30", TimeHelper.millisecondsToWallclock(90001));
			Assert.assertEquals("59:59", TimeHelper.millisecondsToWallclock((59*60*1000)+59002));
		}
		
		[Test(description="Ensures wallclock values for times over an hour are rendered correctly")]
		public function largeWallClockValuesRendered():void
		{
			Assert.assertEquals("01:00", TimeHelper.millisecondsToWallclock(60*60*1000));
			Assert.assertEquals("02:00", TimeHelper.millisecondsToWallclock(120*60*1000));
			Assert.assertEquals("02:02", TimeHelper.millisecondsToWallclock((120*60*1000)+(2*60*1000)));
		}
		
	}
}
