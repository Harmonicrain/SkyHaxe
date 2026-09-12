import com.sulake.core.utils.Map;
import com.sulake.core.utils.SingleWriteMap;

class G1dMapTest {
    private static var assertions:Int = 0;

    public static function main():Void {
        testOrderedApi();
        testDynamicKeySemantics();
        testCloneAndConcatenate();
        testLegacyQuirks();
        testSingleWriteMap();
        testLifecycle();
        trace('G1D_MAP_PASS assertions=$assertions');
    }

    private static function testOrderedApi():Void {
        var map = new Map();
        equal(true, map.add("b", 2), "first add succeeds");
        equal(true, map.unshift("a", 1), "unshift succeeds");
        equal(false, map.add("a", 99), "duplicate non-null key is rejected");
        equal(2, map.length, "length tracks insertion");
        arrayEqual(["a", "b"], map.getKeys(), "keys retain order");
        arrayEqual([1, 2], map.getValues(), "values retain order");
        equal(1, map.getWithIndex(0), "indexed value lookup");
        equal("b", map.getKey(1), "indexed key lookup");
        equal(null, map.getKey(-1), "negative index is rejected");
        equal(null, map.getWithIndex(2), "upper bound is rejected");
        equal(true, map.hasKey("a"), "hasKey finds an inserted key");
        equal(false, map.hasKey("missing"), "hasKey rejects an absent key");
        equal(true, map.hasValue(2), "hasValue finds an inserted value");
        equal(false, map.hasValue(99), "hasValue rejects an absent value");
        equal(1, map.indexOf(2), "indexOf follows value order");

        map.setValue("a", 3);
        arrayEqual(["a", "b"], map.getKeys(), "replacement keeps key order");
        arrayEqual([3, 2], map.getValues(), "replacement updates value in place");
        equal(3, map.getValue("a"), "explicit Proxy read replacement");

        var iterated:Array<Dynamic> = [];
        for (key in map) {
            iterated.push(key);
        }
        arrayEqual(["a", "b"], iterated, "Haxe iteration follows AS3 key iteration");
        equal("Map", map.toString(), "Proxy toString contract");

        var numericKeyMap = new Map();
        numericKeyMap.add(7, "seven");
        equal("seven", numericKeyMap.getValue("7"),
            "AS3 Dictionary numeric keys are readable through their property string");
        equal(false, numericKeyMap.add("7", "duplicate"),
            "numeric and decimal-string keys share one Dictionary slot");
        equal("seven", numericKeyMap.remove("7"),
            "decimal-string removal resolves a numeric Dictionary key");
        equal(0, numericKeyMap.length, "cross-form removal updates ordered storage");

        var keys = map.getKeys();
        keys.push("mutation");
        equal(2, map.length, "getKeys returns a defensive copy");
        var values = map.getValues();
        values.push(99);
        equal(2, map.length, "getValues returns a defensive copy");

        equal(2, map.remove("b"), "normal removal returns its value");
        arrayEqual(["a"], map.getKeys(), "normal removal updates key order");
        equal(null, map.getValue("b"), "normal removal deletes dictionary entry");
    }

    private static function testDynamicKeySemantics():Void {
        var map = new Map();
        var objectKeyA = {};
        var objectKeyB = {};
        map.add(1, "integer");
        equal(false, map.add("1", "string"), "numeric primitive key is canonicalised");
        map.add(objectKeyA, "object-a");

        equal(2, map.length, "primitive property keys coalesce while object keys remain distinct");
        equal("integer", map.getValue(1), "integer key lookup");
        equal("integer", map.getValue("1"), "decimal-string lookup shares the numeric slot");
        equal("object-a", map.getValue(objectKeyA), "object identity lookup");
        equal(null, map.getValue(objectKeyB), "different object is a different key");
    }

    private static function testCloneAndConcatenate():Void {
        var source = new Map();
        source.add("a", 1);
        source.add("b", 2);

        var clone = source.clone();
        arrayEqual(source.getKeys(), clone.getKeys(), "clone copies keys");
        arrayEqual(source.getValues(), clone.getValues(), "clone copies values");
        clone.setValue("a", 9);
        equal(1, source.getValue("a"), "clone has independent storage");

        var target = new Map();
        target.add("z", 0);
        target.concatenate(source);
        arrayEqual(["z", "a", "b"], target.getKeys(), "concatenate appends in source order");
        target.concatenate(source);
        arrayEqual(["z", "a", "b"], target.getKeys(), "concatenate rejects existing non-null keys");
    }

    private static function testLegacyQuirks():Void {
        var nullMap = new Map();
        equal(true, nullMap.add("nullable", null), "null value can be added");
        equal(true, nullMap.add("nullable", null), "AS3 null-value duplicate-key quirk is retained");
        equal(2, nullMap.length, "null duplicate increments length");
        equal(null, nullMap.remove("nullable"), "AS3 cannot remove a null-valued entry");
        equal(2, nullMap.length, "failed null removal leaves entries intact");

        var shared = {};
        var sharedValueMap = new Map();
        sharedValueMap.add("first", shared);
        sharedValueMap.add("second", shared);
        equal(shared, sharedValueMap.remove("second"), "remove returns requested dictionary value");
        arrayEqual(["second"], sharedValueMap.getKeys(), "AS3 shared-value removal quirk is retained");
        equal(shared, sharedValueMap.getValue("first"), "unrequested dictionary entry remains");
        equal(null, sharedValueMap.getValue("second"), "requested dictionary entry is deleted");
    }

    private static function testSingleWriteMap():Void {
        var map = new SingleWriteMap();
        map.setValue(4000, "IncomingClass");
        equal("IncomingClass", map.getValue(4000), "initial single-write assignment works");

        var threw = false;
        try {
            map.setValue(4000, "Collision");
        } catch (_:Dynamic) {
            threw = true;
        }
        equal(true, threw, "single-write collision throws");
        equal("IncomingClass", map.getValue(4000), "collision preserves original value");
    }

    private static function testLifecycle():Void {
        var map = new Map();
        map.add("a", 1);
        map.reset();
        equal(0, map.length, "reset clears length");
        arrayEqual([], map.getKeys(), "reset clears keys");
        map.add("b", 2);
        equal(2, map.getValue("b"), "map can be reused after reset");

        map.dispose();
        equal(true, map.disposed, "dispose marks map disposed");
        equal(0, map.length, "dispose clears length");
        map.dispose();
        equal(true, map.disposed, "dispose is idempotent");
    }

    private static function arrayEqual(expected:Array<Dynamic>, actual:Array<Dynamic>, message:String):Void {
        equal(expected.length, actual.length, '$message (length)');
        for (index in 0...expected.length) {
            equal(expected[index], actual[index], '$message (index $index)');
        }
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
