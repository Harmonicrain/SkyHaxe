package mx.utils;

/**
 * Browser/OpenFL compatibility for the one Flex StringUtil API used by the
 * original client.  This preserves mx.utils.StringUtil.trim semantics at the
 * removed Flex runtime boundary; it is not a client-service replacement.
 */
class StringUtil {
    public static function trim(value:String):String {
        return value == null ? null : StringTools.trim(value);
    }
}
