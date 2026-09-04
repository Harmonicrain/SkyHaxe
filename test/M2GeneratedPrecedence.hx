#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;

/** Compile-time proof that the M2 frontier resolves to generated files, not same-name hand ports. */
class M2GeneratedPrecedence {
    static function absolute(path:String):String {
        var normalized = Path.normalize(path).split("\\").join("/");
        if (!Path.isAbsolute(normalized)) {
            normalized = Path.normalize(Sys.getCwd() + "/" + normalized).split("\\").join("/");
        }
        return normalized.toLowerCase();
    }

    public static function assertGenerated():Void {
        var frontier = Path.normalize(Sys.getCwd() + "/test/M2RuntimeCompileMain.hx");
        var source = File.getContent(frontier);
        var matcher = ~/static var [A-Za-z_]\w*:([A-Za-z0-9_.]+);/g;
        var offset = 0;
        var identities = new Array<String>();
        while (matcher.matchSub(source, offset)) {
            identities.push(matcher.matched(1));
            var found = matcher.matchedPos();
            offset = found.pos + found.len;
        }
        if (identities.length == 0) {
            Context.fatalError("M2 generated-precedence guard found no frontier identities", Context.currentPos());
        }

        var generatedRoot = absolute(Sys.getCwd() + "/generated") + "/";
        var collisions = 0;
        for (identity in identities) {
            var resolved = Context.follow(Context.getType(identity));
            var position = switch resolved {
                case TInst(reference, _): reference.get().pos;
                case other:
                    Context.fatalError("M2 frontier identity is not a class/interface: " + identity,
                        Context.currentPos());
            };
            var actual = absolute(Context.getPosInfos(position).file);
            var expected = generatedRoot + identity.split(".").join("/").toLowerCase() + ".hx";
            if (actual != expected) {
                Context.fatalError("M2 generated precedence violated for " + identity
                    + ": resolved " + actual + ", expected " + expected, position);
            }
            var handPath = Path.normalize(Sys.getCwd() + "/src/" + identity.split(".").join("/") + ".hx");
            if (FileSystem.exists(handPath)) collisions++;
        }
        if (collisions == 0) {
            Context.fatalError("M2 precedence guard has no same-identity collision canary",
                Context.currentPos());
        }
        Sys.println("M2_GENERATED_PRECEDENCE_PASS identities=" + identities.length
            + " collisions=" + collisions);
    }
}
#end
