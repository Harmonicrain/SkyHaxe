package com.sulake.core.utils;

import haxe.ds.StringMap;

/**
 * Explicit replacement for Flash getDefinitionByName().
 *
 * Manifest-only classes must be registered by generated/bootstrap code so
 * Haxe dead-code elimination cannot remove them before runtime lookup.
 */
class DefinitionRegistry {
    private static final definitions = new StringMap<Dynamic>();

    public static function register(name:String, definition:Dynamic):Void {
        if (name == null || name == "" || definition == null) {
            throw new haxe.Exception("Definition registration requires a name and value");
        }

        var haxeName = ClassUtils.toHaxeName(name);
        var existing = definitions.get(haxeName);
        if (existing != null && existing != definition) {
            throw new haxe.Exception('Definition already registered: $name');
        }
        definitions.set(haxeName, definition);
    }

    public static function registerClass(type:Class<Dynamic>):Void {
        var name = Type.getClassName(type);
        if (name == null) {
            throw new haxe.Exception("Cannot register an unnamed class");
        }
        register(name, type);
    }

    public static function resolve(name:String):Dynamic {
        var haxeName = ClassUtils.toHaxeName(name);
        var registered = definitions.get(haxeName);
        if (registered != null) {
            return registered;
        }

        var resolvedClass = Type.resolveClass(haxeName);
        if (resolvedClass != null) {
            return resolvedClass;
        }
        var resolvedEnum = Type.resolveEnum(haxeName);
        if (resolvedEnum != null) {
            return resolvedEnum;
        }
        throw new haxe.Exception('Definition not found: $name');
    }

    public static function exists(name:String):Bool {
        try {
            resolve(name);
            return true;
        } catch (_:Dynamic) {
            return false;
        }
    }

    public static function reset():Void {
        definitions.clear();
    }
}
