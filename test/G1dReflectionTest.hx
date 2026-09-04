import com.sulake.core.utils.ClassUtils;
import com.sulake.core.utils.DefinitionRegistry;

class G1dReflectionTest {
    private static var assertions:Int = 0;

    public static function main():Void {
        testNames();
        testInterfacesWithoutConstruction();
        testDefinitionRegistry();
        trace('G1D_REFLECTION_PASS assertions=$assertions');
    }

    private static function testNames():Void {
        var instance = new ReflectionChild("constructed");
        var instanceName = ClassUtils.getQualifiedClassName(instance);
        var className = ClassUtils.getQualifiedClassName(ReflectionChild);
        equal(instanceName, className, "class and instance names match");
        equal("ReflectionChild", ClassUtils.getSimpleQualifiedClassName(instance), "simple class name");
        equal("int", ClassUtils.getQualifiedClassName(7), "AS3 integer name");
        equal("Number", ClassUtils.getQualifiedClassName(1.5), "AS3 number name");
        equal("Boolean", ClassUtils.getQualifiedClassName(true), "AS3 boolean name");
        equal("String", ClassUtils.getQualifiedClassName("hello"), "AS3 string name");
        equal("null", ClassUtils.getQualifiedClassName(null), "AS3 null name");
        equal("com.sulake::Example", ClassUtils.toActionScriptName("com.sulake.Example"), "AS3 namespace form");
        equal("com.sulake.Example", ClassUtils.toHaxeName("com.sulake::Example"), "Haxe namespace form");
    }

    private static function testInterfacesWithoutConstruction():Void {
        ReflectionBase.constructorCalls = 0;
        equal(true, ClassUtils.implementsInterface(ReflectionBase, IReflectionMarker), "direct interface");
        equal(true, ClassUtils.implementsInterface(ReflectionChild, IReflectionMarker), "inherited interface");
        equal(false, ClassUtils.implementsInterface(ReflectionOther, IReflectionMarker), "unimplemented interface");
        equal(0, ReflectionBase.constructorCalls, "interface checks do not call constructors");
    }

    private static function testDefinitionRegistry():Void {
        DefinitionRegistry.reset();
        equal(
            ReflectionOther,
            DefinitionRegistry.resolve(Type.getClassName(ReflectionOther)),
            "linked Haxe class fallback"
        );
        DefinitionRegistry.register("legacy::Component", ReflectionChild);
        equal(ReflectionChild, DefinitionRegistry.resolve("legacy::Component"), "AS3 name lookup");
        equal(ReflectionChild, DefinitionRegistry.resolve("legacy.Component"), "normalized name lookup");
        equal(true, DefinitionRegistry.exists("legacy::Component"), "registered definition exists");
        equal(false, DefinitionRegistry.exists("missing::Component"), "missing definition is reported");

        var duplicateThrew = false;
        try {
            DefinitionRegistry.register("legacy.Component", ReflectionOther);
        } catch (_:Dynamic) {
            duplicateThrew = true;
        }
        equal(true, duplicateThrew, "conflicting registration throws");

        var missingThrew = false;
        try {
            DefinitionRegistry.resolve("missing::Component");
        } catch (_:Dynamic) {
            missingThrew = true;
        }
        equal(true, missingThrew, "missing lookup throws");

        DefinitionRegistry.registerClass(ReflectionOther);
        equal(ReflectionOther, DefinitionRegistry.resolve(Type.getClassName(ReflectionOther)), "class self-registration");
    }

    private static function equal(expected:Dynamic, actual:Dynamic, message:String):Void {
        assertions++;
        if (!same(expected, actual)) {
            throw new haxe.Exception('$message: expected ${Std.string(expected)}, got ${Std.string(actual)}');
        }
    }

    private static inline function same(left:Dynamic, right:Dynamic):Bool {
        #if js
        return js.Syntax.strictEq(left, right);
        #else
        return left == right;
        #end
    }
}

private interface IReflectionMarker {}

private class ReflectionBase implements IReflectionMarker {
    public static var constructorCalls:Int = 0;

    public function new(required:String) {
        constructorCalls++;
    }
}

private class ReflectionChild extends ReflectionBase {
    public function new(required:String) {
        super(required);
    }
}

private class ReflectionOther {
    public function new() {}
}
