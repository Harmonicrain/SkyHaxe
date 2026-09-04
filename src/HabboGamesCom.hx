/** Logging surface exported by the original HabboGamesCom SWF. */
class HabboGamesCom {
    public static function log(values:Array<Dynamic>):Void {
        Logger.log(values == null ? "" : values.join(" "));
    }
}
