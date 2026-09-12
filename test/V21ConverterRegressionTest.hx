class V21ConverterRegressionTest {
    static function main() {
        if (!Std.isOfType(new mx.core.SimpleApplication(), openfl.display.Sprite))
            throw "Flex SimpleApplication boundary is not an OpenFL display root";
        if (window_conversion.Probe.reservedMember() != 9)
            throw "Reserved AS3 member name was not escaped consistently";
        if (window_conversion.Probe.reservedLocal() != 11)
            throw "Reserved AS3 local name was not escaped consistently";
        if (window_conversion.Probe.staticInstanceCollision() != 9)
            throw "AS3 static/instance member namespace collision changed";
        if (window_conversion.Probe.nativeRestCall().indexOf("Probe") < 0)
            throw "Native variadic call was packed into an Array";
        if (window_conversion.Probe.nativeConstantNoOpSwitch("kept") != "kept")
            throw "No-op native-constant switch was not eliminated";
        if (window_conversion.Probe.byteArrayIndexType() != "f")
            throw "ByteArray indexed value/index types changed";
        if (window_conversion.Probe.uintStringCoercion() != "23")
            throw "uint-to-String coercion changed";
        if (window_conversion.Probe.dynamicNumericLValues() != 4)
            throw "Dynamic numeric lvalue coercion changed";
        if (window_conversion.Probe.dynamicPostfixStatement() != 2)
            throw "Discarded dynamic postfix assignment changed";
        if (window_conversion.Probe.nestedSuperCall() != 13)
            throw "Nested explicit super call gained a second implicit super call";
        if (window_conversion.Probe.regexpExecCapture() != "7")
            throw "RegExp.exec capture index became a string property";
        if (window_conversion.Probe.textFormatPlatformFields() != "block")
            throw "TextFormat platform-only fields changed";
        if (window_conversion.Probe.dynamicDateComponents() != 2020)
            throw "Date component coercion changed";
        if (Math.isNaN(window_conversion.Probe.dateParseBoundary()))
            throw "Date.parse browser boundary changed";
        if (window_conversion.Probe.byteArrayWriteBoundary() != 7)
            throw "ByteArray.writeBytes browser boundary changed";
        if (window_conversion.Probe.mapProxyRouting() != "value:true")
            throw "Map indexed writes bypassed the generated setProperty override";
        if (window_conversion.Probe.typeLikeWildcardImport() != 17)
            throw "Type-like package wildcard import was not expanded";
        if (window_conversion.Probe.numericRegexReplacement() != "7-7")
            throw "Numeric regex replacement did not coerce to a string";
        if (window_conversion.Probe.matchPatterns() != "post_it_:post:0:2")
            throw "String.match pattern coercion, captures, metadata or null changed";
        if (window_conversion.Probe.bracedSwitchBreak(1) != "kept:after")
            throw "Braced switch break became a fall-through return";
        if (window_conversion.Probe.terminalDefaultFallthrough(0) != "break:after"
            || window_conversion.Probe.terminalDefaultFallthrough(1) != "fall:return"
            || window_conversion.Probe.terminalDefaultFallthrough(2) != ":return")
            throw "Switch fall-through into terminal default changed";
        if (window_conversion.Probe.xmlWhitespaceSetting() != "3:1: text ")
            throw "XML whitespace settings changed existing nodes or removed significant text";
        var dynamicXml = new com.sulake.core.utils.xml.XML("<root><item/><group><item/></group></root>");
        if (window_conversion.Probe.dynamicDescendants(dynamicXml) != 2
            || window_conversion.Probe.dynamicDescendants(new com.sulake.core.utils.xml.XMLList([dynamicXml])) != 2
            || !window_conversion.Probe.invalidDescendants())
            throw "Dynamic descendant runtime type checks changed";
        if (window_conversion.Probe.wildcardDescendants() != "5:text:2:tail:3")
            throw "Descendant order, wildcard text nodes or XMLList flattening changed";
        if (window_conversion.Probe.singletonXmlIndex() != "kept:false")
            throw "XML singleton indexing did not retain the node";
        if (window_conversion.Probe.declaredStringMethod() != "detail:detail:plain")
            throw "Declared or dynamic toString argument dispatch changed";
        if (window_conversion.Probe.indexedXmlChain() != "a:b:b")
            throw "Indexed XML chains lost their node types";
        if (!window_conversion.Probe.arrayDynamic()
            || window_conversion.Probe.typeName(1) != "number"
            || window_conversion.Probe.typeName("x") != "string"
            || window_conversion.Probe.typeName(null) != "object"
            || window_conversion.Probe.typeName(ASCompat.undefinedValue()) != "undefined"
            || window_conversion.Probe.typeName(new com.sulake.core.utils.xml.XML("<x/>")) != "xml")
            throw "Dynamic Array or typeof semantics changed";
        if (!window_conversion.Probe.objectIn())
            throw "AS3 property-in-object semantics changed";
        if (window_conversion.Probe.vectorFilter() != "1,3")
            throw "Vector.filter lost its AS3 item/index/vector callback contract";
        if (window_conversion.Probe.compactAny() != 6 || window_conversion.Probe.emptyStringConstructor() != ""
            || window_conversion.Probe.primitiveConstructors() != "12:7:true")
            throw "Wildcard initializer or empty String constructor changed";
        if (window_conversion.Probe.multiSortOn() != "2,3,4,1")
            throw "Array.sortOn multi-field ordering changed";
        if (window_conversion.Probe.defaultSortOn() != "Bob,Zulu,alice")
            throw "Array.sortOn optional flags changed";
        if (window_conversion.Probe.mixedArrayString() != "7:chair:true")
            throw "Untyped AS3 array literal lost heterogeneous values";
        if (window_conversion.Probe.bracelessIfElse(0) != "zero:not-positive"
                || window_conversion.Probe.bracelessIfElse(1) != "one:positive"
                || window_conversion.Probe.bracelessIfElse(2) != "other:positive")
            throw "Braceless if/else statement terminators changed";
        if (window_conversion.Probe.functionScopedLoopVars() != "[loop:1]")
            throw "AS3 function-scoped loop variables changed";
        if (!window_conversion.Probe.arrayLogicalAssign())
            throw "Logical assignment to array access changed";
        if (window_conversion.Probe.arrayWithoutParentheses() != 0)
            throw "AS3 new Array without parentheses changed";
        if (window_conversion.Probe.deleteArrayIndex() != "true:2:true:kept")
            throw "AS3 delete changed Array length or hole behavior";
        if (!window_conversion.Probe.dateWithoutParentheses())
            throw "AS3 new Date without parentheses changed";
        if (window_conversion.Probe.tightIfElse(true) != 3
                || window_conversion.Probe.tightIfElse(false) != 4)
            throw "Braceless if/else branch terminator was lost";
        if (window_conversion.Probe.switchFallthrough(1) != "one:shared"
                || window_conversion.Probe.switchFallthrough(2) != "shared"
                || window_conversion.Probe.switchFallthrough(4) != "other"
                || window_conversion.Probe.switchFallthrough(5) != "to:other")
            throw "AS3 switch fall-through changed";
        if (window_conversion.Probe.fieldForEachTarget() != 36)
            throw "Field-target for-each assignment changed";
        if (window_conversion.Probe.dynamicStringSearch("badge") != 12)
            throw "Dynamic String.search changed";
        if (window_conversion.Probe.nestedXmlCastChild() != "chair")
            throw "Nested E4X inside XML coercion changed";
        if (window_conversion.Probe.deleteDynamicField(false) != "true:false:yes"
                || window_conversion.Probe.deleteDynamicField(true) != "true:false:yes")
            throw "Dynamic field deletion changed";
        if (!window_conversion.Probe.platformDate())
            throw "Flash platform Date/GC boundary changed";
        if (window_conversion.Probe.bracedGuardedSwitch(true) != 3
                || window_conversion.Probe.bracedGuardedSwitch(false) != 8)
            throw "Conditional switch exit in a braced case changed";
        if (window_conversion.Probe.catchBreakSwitch(false) != "start:try:tail"
                || window_conversion.Probe.catchBreakSwitch(true) != "start:catch")
            throw "Catch-nested switch exit changed";
        if (window_conversion.Probe.dynamicPostfixMutatingIndex() != "1:4,9,12")
            throw "Dynamic postfix write repeated its mutating array index";
        if (window_conversion.Probe.bracelessGuardedSwitch(true) != 1
                || window_conversion.Probe.bracelessGuardedSwitch(false) != 9)
            throw "Braceless guarded switch exit changed";
        if (window_conversion.Probe.arrayFilterCallback() != "3")
            throw "AS3 Array.filter callback arguments changed";
        if (!window_conversion.Probe.errorClassReference())
            throw "Expression-level Error class reference escaped ASError mapping";
        if (window_conversion.Probe.stageModeConstants() != "showAll:noScale:fullScreen:normal")
            throw "Flash stage mode string constants changed";
        if (window_conversion.Probe.voidExpressionValue() != "1:1")
            throw "AS3 void expression did not produce one undefined value";
        if (window_conversion.Probe.dynamicClassProperty() != "asset")
            throw "Dynamic AS3 Class property did not use the reflection boundary";
        if (window_conversion.Probe.loaderContextParameters() != "context")
            throw "LoaderContext parameters read/write boundary changed";
        if (window_conversion.Probe.recursiveSetter() != 1)
            throw "Explicit-this recursive property setter bypassed its generated setter";
        if (!window_conversion.Probe.looseBooleanEquality())
            throw "AS3 Boolean/numeric loose equality changed";
        if (window_conversion.Probe.objectStringIndex() != "ready:done")
            throw "AS3 Object string-index property access changed";
        if (window_conversion.Probe.stringTernary(false) != "value:7"
                || window_conversion.Probe.stringTernary(true) != "value:none")
            throw "String-context ternary branch coercion changed";
        if (window_conversion.Probe.xmlStringDelegate() != "CHAIR")
            throw "E4X simple-content String method delegation changed";
        if (window_conversion.Probe.partialAnyReturn(true) != "value"
                || window_conversion.Probe.partialAnyReturn(false) != ASCompat.undefinedValue())
            throw "AS3 partial :* return did not fall through as undefined";
        if (!window_conversion.Probe.dynamicOwnProperty())
            throw "Dynamic hasOwnProperty boundary changed";
        if (window_conversion.Probe.dynamicDateMilliseconds() != 1250)
            throw "Dynamic Date constructor boundary changed";
        if (window_conversion.Probe.dynamicArrayConcat(false) != "1,2"
                || window_conversion.Probe.dynamicArrayConcat(true) != "1,2,3")
            throw "Dynamic Array.concat boundary changed";
        if (window_conversion.Probe.typedDynamicProperties() != "instance")
            throw "Typed object dynamic property boundary changed";
        if (window_conversion.Probe.coercedArrayIndexes() != "one:zero")
            throw "AS3 Array index coercion changed";
        if (window_conversion.Probe.booleanStringConcatenation() != "flags:true:false")
            throw "AS3 Boolean string coercion changed";
        if (window_conversion.Probe.arrayStringConcatenation() != "values:1,two,true")
            throw "AS3 Array string coercion changed";
        if (window_conversion.Probe.reflectedDynamicIteration() != 2)
            throw "Reflected dynamic for-in iteration changed";
        if (window_conversion.Probe.broadSetterTypedGetter() != 17)
            throw "Broad AS3 setter / typed getter contract changed";
        if (window_conversion.Probe.implicitNullableString() != "null"
                || window_conversion.Probe.explicitUndefinedString() != "undefined"
                || window_conversion.Probe.implicitDictionaryString() != "null")
            throw "Implicit nullable String coercion was confused with explicit String()";
        if (window_conversion.Probe.attributeIndex() != "16777215:true:false") throw "E4X attribute indexed characters instead of nodes";
        if (!window_conversion.Probe.nativeErrorCatch()) throw "Root Error did not catch VM TypeError";
        var thrown:Dynamic = null;
        try { window_conversion.Probe.throwNonError(); } catch (error:Dynamic) { thrown = error; }
        if (thrown != "unchanged") throw "Root Error caught a non-Error value";
        if (window_conversion.Probe.replaceString("aa", "a", "b") != "ba"
            || window_conversion.Probe.replaceDynamic("aa", "a", "$&!") != "a!a"
            || window_conversion.Probe.replaceDynamic("a1a", 1, "X") != "aXa"
            || window_conversion.Probe.replaceDynamic("aa", new js.lib.RegExp("a", "g"), "b") != "bb"
            || window_conversion.Probe.replaceDynamic("aa", "a", function(_:Dynamic) return "Z") != "Za")
            throw "AS3 String.replace coercion/first-match/substitution contract changed";
        if (!window_conversion.Probe.securityError()) throw "SecurityError target mapping changed";
        if (window_conversion.Probe.uintMax() != 0xFFFFFFFF || window_conversion.Probe.uintMin() != 0)
            throw "uint limits changed";
        if (!js.Syntax.code("typeof {0} === 'undefined'", window_conversion.Probe.absentReturn()))
            throw "Implicit :* return was not undefined";
        var proxy = new window_conversion.ProxyProbe();
        if (window_conversion.Probe.proxyIndex(proxy) != "attached" || Reflect.hasField(proxy, "2"))
            throw "Proxy indexed access bypassed hooks";
        if (window_conversion.Probe.proxyValues(proxy) != "AB") throw "Proxy hooks were not used";
        var iterator = com.sulake.core.utils.ASProxy.values(proxy);
        if (!iterator.hasNext() || !iterator.hasNext() || iterator.next() != "A"
                || iterator.next() != "B" || iterator.hasNext()) throw "Proxy iteration state changed";
        if (com.sulake.core.utils.ASProxy.values(null).hasNext()) throw "Null Proxy must be empty";
        var result = window_conversion.Probe.run();
        for (value in [0.0, 1.0, 2147483648.0, 4294967295.0])
            if (!window_conversion.Probe.unsignedType(value)) throw "Valid uint type rejected";
        for (value in [-1.0, 1.5, 4294967296.0, Math.NaN, Math.POSITIVE_INFINITY])
            if (window_conversion.Probe.unsignedType(value)) throw "Invalid uint type accepted";
        if (window_conversion.Probe.unsignedType("1") || window_conversion.Probe.unsignedType(true)
                || window_conversion.Probe.unsignedType(null)) throw "uint test coerced nonnumeric input";
        if (window_conversion.Probe.alignment("center") != 1
                || window_conversion.Probe.alignment("right") != 2
                || window_conversion.Probe.alignment("unknown") != 0)
            throw "Flash text enum case values changed";
        if (window_conversion.Probe.leading(3.9) != 3
                || window_conversion.Probe.leading(-3.9) != -3
                || window_conversion.Probe.unspecifiedLeading() != null)
            throw "TextFormat leading coercion or null changed";
        if (result != "hello:117") throw 'Unexpected conversion result: $result';
        window_conversion.Probe.status = 4;
        window_conversion.Probe.status = -1;
        if (window_conversion.Probe.status != 0) throw "Self-setter call did not dispatch";
        for (value in [Math.NaN, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY]) {
            if (window_conversion.Probe.shadowOffset(value, 64) != 0
                    || window_conversion.Probe.floorInt(value) != 0
                    || window_conversion.Probe.roundInt(value) != 0)
                throw "Nonfinite rounding must coerce to zero at int boundary";
        }
        if (window_conversion.Probe.shadowOffset(0.1, 64) != 4
                || window_conversion.Probe.shadowOffset(-0.1, 64) != -3
                || window_conversion.Probe.shadowOffset(0.1, 32) != 2)
            throw "Finite shadow lift changed";
        if (!Math.isNaN(window_conversion.Probe.ceilNumber(Math.NaN)))
            throw "Number-valued rounding must preserve NaN";
        if (window_conversion.Probe.floorInt(4294967297.0) != 1)
            throw "int rounding must preserve 32-bit wraparound";
        trace("V21_CONVERTER_PASS XML-index-string XML-index-bool XML-string-equality interface-loop reference-equality inherited-accessors runtime-class");
        trace("SHADOW_INT_COERCION_PASS nonfinite-zero finite-lift number-NaN wraparound");
    }
}
