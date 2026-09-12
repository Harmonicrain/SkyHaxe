class Globals {
	public static function flash_net_sendToURL(arg0:flash.net.URLRequest) {
		ASCompat.globalFunction("flash.net.sendToURL")(arg0);
	}
	public static function flash_utils_getQualifiedClassName(arg0:ASAny):String {
		return ASCompat.globalFunction("flash.utils.getQualifiedClassName")(arg0);
	}
	public static var com_hurlant_math_bi_internal(get,never):ASAny;
	static function get_com_hurlant_math_bi_internal():ASAny {
		return ASCompat.globalFunction("com.hurlant.math.bi_internal");
	}

	public function new() {}
}
