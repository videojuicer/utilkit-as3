package org.utilkit.crypto
{
	import com.hurlant.crypto.hash.SHA1;
	
	import org.utilkit.util.ByteHelper;

	public class GUID
	{
		public static function create(salt:String = ""):String
		{
			if (salt == "")
			{
				salt = MD5.encrypt(new Date().getTime().toString());
			}
			
			const id1: Number = new Date().getTime();
			const id2: Number = Math.random();
			const sha1: String = ByteHelper.encode(new SHA1().hash(ByteHelper.decode(id1 + id2 + salt)));
			
			return GUID.sha1ToGUID(sha1).toUpperCase();
		}
		
		public static function sha1ToGUID(s:String):String
		{
			return [ s.substr(0, 8), s.substr(8, 4), s.substr(12, 4), s.substr(16, 4), s.substr(20, 12) ].join("-");
		}
	}
}