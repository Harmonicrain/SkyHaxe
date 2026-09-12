class V32HabboHostTest {
    static function assert(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    public static function main():Void {
        assert(Habbo.CORE_RATIO == 0.6, "HabboMain progress ratio changed");
        Habbo.trackLoginStep("v32.host.test", "detail");
        Habbo.reportCrash("non-fatal host test", 0, false);
        trace("V32_HABBO_HOST_PASS");
    }
}
