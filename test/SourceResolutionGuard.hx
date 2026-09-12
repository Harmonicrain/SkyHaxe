#if macro
import haxe.macro.Context;
import haxe.io.Path;
import sys.FileSystem;

/** Assert the selected source file without needing a half-migrated class to type-check. */
class SourceResolutionGuard {
    public static function expect(identity:String, expected:String):Void {
        var resolved = Context.resolvePath(identity.split(".").join("/") + ".hx");
        var actual = Path.normalize(FileSystem.fullPath(resolved)).toLowerCase();
        var required = Path.normalize(FileSystem.fullPath(expected)).toLowerCase();
        if (actual != required)
            Context.fatalError('Source resolution for $identity: $actual; expected $required',
                Context.currentPos());
        Sys.println('SOURCE_RESOLUTION_PASS $identity -> $resolved');
    }
}
#end
