package com.sulake.core.utils;

class ClassUtils {
    public static function implementsInterface(
        testedClass:Class<Dynamic>,
        interfaceClass:Class<Dynamic>
    ):Bool {
        if (testedClass == null || interfaceClass == null) {
            return false;
        }

        // The clean client used describeType() so constructors were never run.
        // createEmptyInstance preserves that property while Std.isOfType handles
        // inherited interface implementation on Haxe targets.
        try {
            return Std.isOfType(Type.createEmptyInstance(testedClass), interfaceClass);
        } catch (_:Dynamic) {
            return false;
        }
    }

    public static function getQualifiedClassName(value:Dynamic):String {
        if (value == null) {
            return "null";
        }

        var directClassName = classObjectName(value);
        if (directClassName != null) {
            return toActionScriptName(directClassName);
        }

        return switch (Type.typeof(value)) {
            case TInt: "int";
            case TFloat: "Number";
            case TBool: "Boolean";
            case TFunction: "Function";
            case TClass(type): toActionScriptName(Type.getClassName(type));
            case TEnum(type): toActionScriptName(Type.getEnumName(type));
            case TObject: "Object";
            case TNull: "null";
            case TUnknown: "Object";
        };
    }

    public static function getSimpleQualifiedClassName(value:Dynamic):String {
        var name = getQualifiedClassName(value);
        var namespaceIndex = name.lastIndexOf("::");
        return namespaceIndex >= 0 ? name.substr(namespaceIndex + 2) : name;
    }

    public static function toHaxeName(actionScriptName:String):String {
        return StringTools.replace(actionScriptName, "::", ".");
    }

    public static function toActionScriptName(haxeName:String):String {
        if (haxeName == null) {
            return "null";
        }
        var separator = haxeName.lastIndexOf(".");
        return separator < 0
            ? haxeName
            : haxeName.substr(0, separator) + "::" + haxeName.substr(separator + 1);
    }

    private static function classObjectName(value:Dynamic):Null<String> {
        try {
            return Type.getClassName(cast value);
        } catch (_:Dynamic) {
            return null;
        }
    }
}
