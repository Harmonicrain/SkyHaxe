package window_conversion
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.LoaderInfo;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.text.TextFormat;
    import flash.display.StageScaleMode;
    import flash.display.StageDisplayState;
    import flash.system.LoaderContext;
    import com.sulake.core.utils.Map;
    import com.sulake.core.utils.SingleWriteMap;
    import window_conversion._Str_900.*;

    public class Probe extends Event implements IProbe
    {
        private static var fieldLoopValue:int;
        private static var voidCallCount:int;
        private var redirectedValue:int;
        private var flexibleValue:int;
        public function set redirected(k:int):void {
            if (k > 1) { this.redirected = 1; return; }
            this.redirectedValue = k;
        }
        public function get redirected():int { return this.redirectedValue; }
        public function set flexible(k:*):void { this.flexibleValue = int(k); }
        public function get flexible():int { return this.flexibleValue; }
        public function get final():int { return 9; }
        public static function reservedMember():int { return new Probe().final; }
        public static function reservedLocal():int { var final:int = 11; return final; }
        public static function staticInstanceCollision():int { return new Probe().collision() + Probe.collision(); }
        public static function collision():int { return 4; }
        public function collision():int { return 5; }
        public static function nativeRestCall():String { return new Probe().formatToString("Probe", "type"); }
        public static function nativeConstantNoOpSwitch(value:String):String {
            switch (value) {
                case IOErrorEvent.IO_ERROR: break;
                case IOErrorEvent.DISK_ERROR: break;
            }
            return value;
        }
        public static function byteArrayIndexType():String {
            var bytes:ByteArray = new ByteArray();
            bytes[0] = 15;
            return bytes[0].toString(16);
        }
        public static function uintStringCoercion():String {
            var value:uint = 23;
            return value;
        }
        public static function dynamicNumericLValues():int {
            var values:Array = [1];
            values[0] |= 2;
            ++values[0];
            return values[0];
        }
        public static function dynamicPostfixStatement():int {
            var values:Array = [1];
            values[0]++;
            return values[0];
        }
        public static function nestedSuperCall():int { return new TrySuper(13).value(); }
        public static function loaderParameter(info:LoaderInfo, key:String):String {
            return info.parameters[key];
        }
        public static function regexpExecCapture():String {
            return /value=(\d+)/.exec("value=7")[1];
        }
        public static function textFormatPlatformFields():String {
            var source:TextFormat = new TextFormat("Ubuntu", 12, 4288716960);
            var copy:TextFormat = new TextFormat();
            source.display = "block";
            copy.display = source.display;
            return String(copy.display);
        }
        public static function dynamicDateComponents():int {
            var month:* = 0;
            return new Date(2020, month, 2, 3, 4, 5, 0).fullYear;
        }
        public static function dateParseBoundary():Number {
            return Date.parse("2020-01-02");
        }
        public static function byteArrayWriteBoundary():int {
            var source:ByteArray = new ByteArray();
            source.writeByte(7);
            source.position = 0;
            var target:ByteArray = new ByteArray();
            target.writeBytes(source, 0, 1);
            target.position = 0;
            return target.readUnsignedByte();
        }
        public static function mapProxyRouting():String {
            var values:Map = new Map();
            values["key"] = "value";
            var single:Map = new SingleWriteMap();
            single["fixed"] = 1;
            var rejected:Boolean = false;
            try { single["fixed"] = 2; }
            catch (error:Error) { rejected = true; }
            return values["key"] + ":" + rejected;
        }
        public static function typeLikeWildcardImport():int { return ImportedByWildcard.value(); }
        public static function numericRegexReplacement():String {
            return "a-a".replace(/a/g, 7);
        }
        public static function matchPatterns():String {
            var value:String = "post_it_blue";
            var dynamicPattern:* = "(post)_it_";
            var found:Array = value.match(dynamicPattern);
            if (value.match("absent") != null || value.match(/absent/) != null) return "wrong-null";
            return value.match("post_it_")[0] + ":" + found[1] + ":" + found.index
                + ":" + "aba".match(/a/g).length;
        }
        public static function bracedSwitchBreak(value:int):String {
            var result:String = "";
            switch (value) {
                case 1: { result += "kept"; break; }
                default: return "default";
            }
            return result + ":after";
        }
        public static function terminalDefaultFallthrough(value:int):String {
            var result:String = "";
            switch (value) {
                case 0: result += "break"; break;
                case 1: result += "fall";
                default: return result + ":return";
            }
            return result + ":after";
        }
        public static function xmlWhitespaceSetting():String {
            var previous:Boolean = XML.ignoreWhitespace;
            XML.ignoreWhitespace = false;
            var preserved:XML = new XML('<root> <item/> </root>');
            XML.ignoreWhitespace = true;
            var stripped:XML = new XML('<root> <item/> </root>');
            var text:XML = new XML('<root> text </root>');
            var result:String = preserved.children().length() + ":" + stripped.children().length()
                + ":" + text.toString();
            XML.ignoreWhitespace = previous;
            return result;
        }
        public static function dynamicDescendants(value:*):int { return value..item.length(); }
        public static function invalidDescendants():Boolean {
            try { dynamicDescendants({item:"not XML"}); }
            catch (error:Error) { return true; }
            return false;
        }
        public static function wildcardDescendants():String {
            var xml:XML = new XML('<root><a><b>text</b></a><b>tail</b></root>');
            var all:XMLList = xml..*;
            var named:XMLList = xml..b;
            var roots:XMLList = xml.children();
            var nested:XMLList = roots..*;
            return all.length() + ":" + all[2].toString() + ":" + named.length()
                + ":" + named[1].toString() + ":" + nested.length();
        }
        public static function singletonXmlIndex():String {
            var xml:XML = new XML('<item value="kept"/>');
            return String(xml[0].@value) + ":" + Boolean(xml[1]);
        }
        public static function declaredStringMethod():String {
            var typed:StringProbe = new StringProbe();
            var dynamicValue:* = typed;
            return typed.toString(true) + ":" + dynamicValue.toString(true) + ":" + typed.toString();
        }
        public static function indexedXmlChain():String {
            var xml:XML = new XML('<root><group><item base="a"/></group><group><item base="b"/></group></root>');
            var groups:XMLList = xml.children();
            var index:int = 1;
            return xml.children()[0].children()[0].@base.toString() + ":"
                + groups[index].children()[0].@base.toString() + ":"
                + groups.children().attribute("base")[1].toString();
        }
        public static function typeName(value:*):String { return typeof(value); }
        public static function objectIn():Boolean {
            var value:Object = {present: 1};
            return ("present" in value) && !("absent" in value);
        }
        public static function arrayDynamic():Boolean {
            var list:Array = [1, 2];
            if (list.count !== undefined) return false;
            list.extra = "value";
            return list.extra == "value" && list.length == 2;
        }
        public static function vectorFilter():String {
            var source:Vector.<int> = new <int>[1, 2, 3, 4];
            var result:Vector.<int> = source.filter(function (item:int, index:int, vector:Vector.<int>):Boolean {
                return ((item % 2) == 1) && (vector[index] == item);
            });
            return result.join(",");
        }
        public static function compactAny(value:*=3):int { var factor:*=2; factor *= value; return factor; }
        public static function emptyStringConstructor():String { return new String(); }
        public static function primitiveConstructors():String { return String(new Number("12")) + ":" + new String(7) + ":" + new Boolean(1); }
        public static function multiSortOn():String {
            var values:Array = [
                { id: 1, pocketHabboUser: false, name: "Zulu" },
                { id: 2, pocketHabboUser: true, name: "alice" },
                { id: 3, pocketHabboUser: true, name: "Bob" },
                { id: 4, pocketHabboUser: false, name: "alpha" }
            ];
            values.sortOn(["pocketHabboUser", "name"],
                [(Array.NUMERIC | Array.DESCENDING), Array.CASEINSENSITIVE]);
            return values[0].id + "," + values[1].id + "," + values[2].id + "," + values[3].id;
        }
        public static function defaultSortOn():String {
            var values:Array = [{name:"Zulu"}, {name:"alice"}, {name:"Bob"}];
            values.sortOn("name");
            return values[0].name + "," + values[1].name + "," + values[2].name;
        }
        public static function proxyIndex(iterator:com.sulake.core.window.utils.IIterator):String {
            iterator[iterator.length] = "attached";
            return String(iterator[iterator.length]);
        }
        public static function attributeIndex():String {
            var xml:XML = new XML('<x color="16777215" empty=""/>');
            return String(xml.@color[0]) + ":" + Boolean(xml.@empty[0]) + ":" + Boolean(xml.@missing[0]);
        }
        public static function nativeErrorCatch():Boolean {
            try { var absent:Object = null; absent.someProperty(); }
            catch (error:Error) { return error.message.length > 0; }
            return false;
        }
        public static function throwNonError():void {
            try { throw "unchanged"; }
            catch (error:Error) { throw "wrongly-caught"; }
        }
        public static function replaceDynamic(value:String, pattern:*, replacement:*):String {
            return value.replace(pattern, replacement);
        }
        public static function replaceString(value:String, pattern:String, replacement:String):String {
            return value.replace(pattern, replacement);
        }
        public static function uintMax():uint { return uint.MAX_VALUE; }
        public static function uintMin():uint { return uint.MIN_VALUE; }
        public static function absentReturn():* { var ignored:int = 1; }
        public static function securityError():Boolean {
            try { throw new SecurityError("fixture"); }
            catch (error:SecurityError) { return error.message == "fixture"; }
            return false;
        }
        public static function proxyValues(iterator:com.sulake.core.window.utils.IIterator):String {
            var output:String = "";
            for each (var value:* in iterator) { output += value; }
            return output;
        }
        public function Probe() { super("probe"); }
        public function value():int { return 7; }
        public function runtimeClass():Class { return Object(this).constructor; }
        private static var _status:int = 0;
        public static function get status():int { return _status; }
        public static function set status(value:int):void {
            if (value < 0) { status = 0; } else { _status = value; }
        }
        public static function shadowOffset(lift:Number, scale:int):int {
            return Math.ceil(lift * (scale / 2));
        }
        public static function floorInt(value:Number):int { return Math.floor(value); }
        public static function roundInt(value:Number):int { return Math.round(value); }
        public static function ceilNumber(value:Number):Number { return Math.ceil(value); }
        public static function glyphs(font:flash.text.Font, text:String):Boolean { return font.hasGlyphs(text); }
        public static function unsignedType(value:*):Boolean { return value is uint; }
        public static function alignment(value:String):int {
            switch (value) {
                case flash.text.TextFieldAutoSize.CENTER: return 1;
                case flash.text.TextFieldAutoSize.RIGHT: return 2;
                default: return 0;
            }
        }
        public static function leading(value:Number):Object {
            var format:flash.text.TextFormat = new flash.text.TextFormat();
            format.leading = value;
            return format.leading;
        }
        public static function unspecifiedLeading():Object {
            var format:flash.text.TextFormat = new flash.text.TextFormat();
            format.leading = null;
            return format.leading;
        }
        public static const COLOR_CONSTANT:uint = 4288528218;
        public static function defaultColor(value:uint = 4288528218):uint { return value; }
        public static function acceptsInt(value:int):int { return value; }
        public static function guardedSwitch(stop:Boolean):int {
            var result:int = 0;
            for (var outer:int = 0; outer < 2; outer++) {
                switch (outer) {
                    case 0:
                        if (stop) { result += 3; break; }
                        for (var inner:int = 0; inner < 5; inner++) { result++; if (inner == 1) { break; } }
                        continue;
                    default:
                        result += 10;
                        break;
                }
                result += 100;
            }
            return result;
        }
        public static function mixedArrayString():String {
            return [7, "chair", true].join(":");
        }
        public static function bracelessIfElse(value:int):String {
            var result:String;
            if (value == 0)
                result = "zero";
            else if (value == 1) result = "one";
            else result = "other";
            if (value > 0) result += ":positive"; else result += ":not-positive";
            return result;
        }
        public static function functionScopedLoopVars():String {
            var result:String = "";
            function decorate(value:String):String { return "[" + value + "]"; }
            if (true) {
                for (var i:int = 0; i < 1; i++) {
                    var label:String = "loop";
                }
            }
            for (i = 1; i < 2; i++) result = label + ":" + i;
            return decorate(result);
        }
        public static function arrayLogicalAssign():Boolean {
            var values:Array = [false, false];
            var index:int = 0;
            values[0] ||= true;
            values[index + 1] ||= true;
            return values[0] && values[1];
        }
        public static function arrayWithoutParentheses():int {
            var values:Array = new Array;
            return values.length;
        }
        public static function deleteArrayIndex():String {
            var values:Array = ["gone", "kept"];
            var removed:Boolean = delete values[0];
            return removed + ":" + values.length + ":" + (values[0] === undefined) + ":" + values[1];
        }
        public static function dateWithoutParentheses():Boolean {
            return new Date is Date;
        }
        public static function tightIfElse(flag:Boolean):int {
            var value:int;
            if (flag) value = 3;else value = 4;
            return value;
        }
        public static function switchFallthrough(value:int):String {
            var result:String = "";
            switch (value) {
                case 1:
                    result += "one:";
                case 2:
                case 3:
                    result += "shared";
                    break;
                case 5:
                    result += "to:";
                default:
                    result += "other";
            }
            return result;
        }
        public static function fieldForEachTarget():int {
            var sum:int = 0;
            for each (fieldLoopValue in [1, 2, 3]) sum += fieldLoopValue;
            return fieldLoopValue * 10 + sum;
        }
        public static function dynamicStringSearch(pattern:*):int {
            return "achievement_badge".search(pattern);
        }
        public static function nestedXmlCastChild():String {
            var source:XML = new XML('<root><window><children><item name="chair"/></children></window></root>');
            return XML(source.window[0]).child("children")[0].children()[0].@name;
        }
        public static function deleteDynamicField(parenthesized:Boolean):String {
            var value:Object = { keep: "yes", gone: "remove" };
            var removed:Boolean = parenthesized ? delete (value.gone) : delete value.gone;
            return removed + ":" + value.hasOwnProperty("gone") + ":" + value.keep;
        }
        public static function platformDate():Boolean {
            flash.system.System.pauseForGCIfCollectionImminent(0.25);
            return new Date().toLocaleString().length > 0;
        }
        public static function platformSoundSignature(sound:flash.media.Sound, output:flash.utils.ByteArray):Number {
            return sound.extract(output, 1, 0);
        }
        public static function bracedGuardedSwitch(stop:Boolean):int {
            var result:int = 0;
            switch (1) {
                case 1: {
                    if (true) {
                        if (stop) { result = 3; break; }
                        result = 8;
                    }
                    break;
                }
            }
            return result;
        }
        public static function catchBreakSwitch(fail:Boolean):String {
            var result:String = "start";
            switch (1) {
                case 1:
                    try {
                        if (fail) { throw new Error("fixture"); }
                        result += ":try";
                    }
                    catch (error:Error) {
                        result += ":catch";
                        break;
                    }
                    result += ":tail";
                    break;
            }
            return result;
        }
        public static function dynamicPostfixMutatingIndex():String {
            var values:Array = [4, 8, 12];
            var index:int = 0;
            values[++index]++;
            return index + ":" + values.join(",");
        }
        public static function bracelessGuardedSwitch(stop:Boolean):int {
            var result:int = 1;
            switch (1) {
                case 1:
                    if (stop) break;
                    result = 9;
                    break;
            }
            return result;
        }
        public static function arrayFilterCallback():String {
            var values:Array = [2, 3, 4];
            return values.filter(function(value:*, index:int, owner:Array):Boolean {
                return value + index == owner.length + 1;
            }).join(",");
        }
        public static function errorClassReference():Boolean {
            var value:Object = new Error("fixture");
            return value is Error && (value as Error).message == "fixture";
        }
        public static function stageModeConstants():String {
            return StageScaleMode.SHOW_ALL + ":" + StageScaleMode.NO_SCALE + ":" + StageDisplayState.FULL_SCREEN + ":" + StageDisplayState.NORMAL;
        }
        private static function touchVoid():void { voidCallCount++; }
        public static function voidExpressionValue():String {
            voidCallCount = 0;
            var values:Array = [];
            values.push(touchVoid());
            return voidCallCount + ":" + values.length;
        }
        public static function dynamicClassProperty():String {
            var assetClass:Class = ClassAssetFixture;
            return assetClass.marker;
        }
        public static function loaderContextParameters():String {
            var loader:LoaderContext = new LoaderContext();
            loader.parameters = { marker: "context" };
            return loader.parameters.marker;
        }
        public static function recursiveSetter():int {
            var probe:Probe = new Probe();
            probe.redirected = 2;
            return probe.redirected;
        }
        public static function looseBooleanEquality():Boolean {
            return true == 1 && false == 0 && true != 0;
        }
        public static function objectStringIndex():String {
            var value:Object = { code: "ready" };
            value["next"] = "done";
            return value["code"] + ":" + value["next"];
        }
        public static function stringTernary(flag:Boolean):String {
            var count:int = 7;
            return "value:" + (flag ? "none" : count);
        }
        public static function xmlStringDelegate():String {
            var node:XML = new XML('<item kind="chair"/>');
            return node.@kind.toUpperCase();
        }
        public static function partialAnyReturn(flag:Boolean):* {
            var callback:Function = function(value:Boolean):* {
                if (value) return "value";
            };
            return callback(flag);
        }
        public static function dynamicOwnProperty():Boolean {
            var value:* = { marker: 1 };
            return value.hasOwnProperty("marker") && !value.hasOwnProperty("missing");
        }
        public static function dynamicDateMilliseconds():Number {
            var value:* = 1250;
            return new Date(value).getTime();
        }
        public static function dynamicArrayConcat(asArray:Boolean):String {
            var value:* = asArray ? [2, 3] : 2;
            return [1].concat(value).join(",");
        }
        public static function typedDynamicProperties():String {
            var fixture:ClassAssetFixture = new ClassAssetFixture();
            return fixture.hasOwnProperty("instanceMarker") ? fixture["instanceMarker"] : "missing";
        }
        public static function coercedArrayIndexes():String {
            var values:Array = ["zero", "one"];
            var numeric:Number = 1.9;
            var dynamicIndex:* = 0;
            return values[numeric] + ":" + values[dynamicIndex];
        }
        public static function booleanStringConcatenation():String {
            return "flags:" + true + ":" + false;
        }
        public static function arrayStringConcatenation():String {
            return "values:" + [1, "two", true];
        }
        public static function reflectedDynamicIteration():int {
            var outer:Object = { items: { first: 1, second: 2 } };
            var count:int = 0;
            for (var key:String in outer["items"]) count++;
            return count;
        }
        public static function broadSetterTypedGetter():int {
            var probe:Probe = new Probe();
            var value:* = "17";
            probe.flexible = value;
            return probe.flexible;
        }
        public static function implicitNullableString():String {
            var values:Object = {};
            var value:String = values["missing"];
            return value == null ? "null" : value;
        }
        public static function explicitUndefinedString():String {
            var values:Object = {};
            return String(values["missing"]);
        }
        public static function implicitDictionaryString():String {
            var values:Dictionary = new Dictionary();
            var value:String = values["missing"];
            return value == null ? "null" : value;
        }
        public static function run():String
        {
            var named:XML = new XML("<item><name>Chair</name></item>");
            var childName:String = named.name;
            if (childName != "Chair" || String(named.name()) != "item" || acceptsInt(named.child("revision")) != 0
                || acceptsInt(new XML("<item><revision>17</revision></item>").revision) != 17) {
                throw new Error("XML name/numeric coercion changed");
            }
            var dispatcher:flash.display.Sprite = new flash.display.Sprite();
            var called:int = 0;
            var listener:Function = function(event:flash.events.MouseEvent):void { called++; };
            dispatcher.addEventListener(flash.events.MouseEvent.CLICK, listener);
            dispatcher.dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.CLICK));
            dispatcher.removeEventListener(flash.events.MouseEvent.CLICK, listener);
            dispatcher.dispatchEvent(new flash.events.MouseEvent(flash.events.MouseEvent.CLICK));
            if (called != 1) { throw new Error("listener identity changed"); }
            const largeColor:uint = 4288528218;
            if (guardedSwitch(true) != 213 || guardedSwitch(false) != 112) { throw new Error("conditional switch exit target changed"); }
            if (largeColor != 0xFF9DBF5A || COLOR_CONSTANT != largeColor || defaultColor() != largeColor || Math.abs(Math.LN2 - Math.log(2)) > 0.000000000000001) {
                throw new Error("unsigned constant or LN2 changed");
            }
            if (!(true > 0) || !(false < 1) || true < false || !((!2) < 1)) {
                throw new Error("Boolean numeric relation changed");
            }
            var instance:Probe = new Probe();
            var reference:IProbe = instance;
            var different:IProbe = new OtherProbe();
            if (!(instance == reference) || !(reference === instance)) {
                throw new Error("same reference differs across static types");
            }
            if (instance == different || different === instance || !(instance !== different)) {
                throw new Error("different reference compares equal");
            }
            reference = null;
            if (instance == reference || !(reference != instance)) {
                throw new Error("null reference comparison changed");
            }
            var property:PropertyChild = new PropertyChild();
            property.amount = 6;
            if (property.amount != 6) { throw new Error("inherited accessor changed"); }
            var objects:Vector.<IProbe> = new Vector.<IProbe>();
            objects.push(instance);
            var concrete:Probe;
            var total:int = 0;
            for each (concrete in objects) { total += concrete.value(); }
            var items:XMLList = new XML("<root><value>hello</value></root>").value;
            var text:String = items[0];
            if (items != "hello" || "hello" != items || items[0] != "hello") {
                throw new Error("E4X simple-content comparison changed");
            }
            var empty:XMLList = new XML("<root/>").missing;
            var many:XMLList = new XML("<root><v>a</v><v>b</v></root>").v;
            var complex:XML = new XML("<root><v/></root>");
            if (empty == "" || many == "ab" || complex == complex.toXMLString()) {
                throw new Error("E4X comparison incorrectly flattened XML");
            }
            if (items[0]) { total += 10; }
            if (instance.runtimeClass() == Probe) { total += 100; }
            return text + ":" + total;
        }
    }
}
