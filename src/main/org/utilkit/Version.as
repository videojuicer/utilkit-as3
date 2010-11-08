package org.utilkit
{
	/**
	 * Version class is used to hold a full version number, provides 
	 * a simple way to convert the <code>version</code> object into
	 * a string.
	 
	 * A <code>version</code> can be made up from a major, minor and
	 * a build uint. 
	 */
	public class Version
	{
		public var major:uint = 0;
		public var minor:uint = 0;
		public var text:String = '';
		public var date:String = '';
		
		public var build:uint = 0;
		
		/**
		 * Returns the version as a string in the following format;
		 * v<major>.<minor>.<build> or v2.1.457
		 */
		public function toString():String
		{
			return this.major + "." + this.minor + (this.text != null ? this.text : "")  + " " + this.build + " " + (this.date != null ? this.date : "");
		}
		
		public function toURLString():String
		{
			return this.major+"."+this.minor+this.text+"."+this.build;
		}
	}
}