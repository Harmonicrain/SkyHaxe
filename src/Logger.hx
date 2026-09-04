/**
 * Compatibility boundary for the clean client's package-less AS3 Logger.
 *
 * Generated message parsers retain diagnostic Logger.log calls, but the original
 * implementation delegates to Habbo.trackLoginStep and would pull the complete
 * application root into every parser-only compile. Keep the observable diagnostic
 * behaviour without introducing that dependency; replace this adapter when the
 * generated application root owns logging.
 */
class Logger {
    public static function log(values:haxe.Rest<Dynamic>):Void {
        trace(values.toArray().join(" "));
    }
}
