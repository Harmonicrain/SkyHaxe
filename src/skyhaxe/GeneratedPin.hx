package skyhaxe;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * Build-time guard for hand-maintained `src/` overrides of generated classes.
 *
 * An override shadows its generated original completely, so a later regeneration would be
 * silently masked. `@:build(skyhaxe.GeneratedPin.check(path, sha256))` fails the build as soon
 * as the generated file no longer matches the version the override was written against.
 */
class GeneratedPin {
    public static function check(generatedPath:String, sha256:String):Array<Field> {
        if (!sys.FileSystem.exists(generatedPath))
            Context.fatalError('Pinned source is missing: $generatedPath', Context.currentPos());
        var actual = haxe.crypto.Sha256.make(sys.io.File.getBytes(generatedPath)).toHex();
        if (actual != sha256)
            Context.fatalError('$generatedPath changed (sha256 $actual); re-sync the override of '
                + Context.getLocalClass().get().name + ' and update its pin', Context.currentPos());
        Context.registerModuleDependency(Context.getLocalModule(), generatedPath);
        return Context.getBuildFields();
    }
}
#end
