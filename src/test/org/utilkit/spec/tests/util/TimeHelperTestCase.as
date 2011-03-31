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
