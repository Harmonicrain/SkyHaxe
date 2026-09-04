package com.sulake.core.runtime;

import com.sulake.core.utils.DefinitionRegistry;
import com.sulake.core.utils.xml.XML;

class ComponentManifestEntry {
    public final className:String;
    public final version:String;
    public final interfaces:Array<String>;

    public function new(className:String, version:String, interfaces:Array<String>) {
        this.className = className;
        this.version = version;
        this.interfaces = interfaces.copy();
    }
}

class ComponentManifest {
    public static function parse(source:String):Array<ComponentManifestEntry> {
        var manifest = new XML(source);
        var result:Array<ComponentManifestEntry> = [];
        for (component in manifest.child("component")) {
            var className = component.attribute("class").toString();
            if (className == "") {
                throw new haxe.Exception("Component manifest entry is missing its class attribute");
            }
            var interfaces:Array<String> = [];
            for (item in component.child("interface")) {
                var iidName = item.attribute("iid").toString();
                if (iidName == "") {
                    throw new haxe.Exception('$className has an interface entry without an iid attribute');
                }
                interfaces.push(iidName);
            }
            result.push(new ComponentManifestEntry(
                className,
                component.attribute("version").toString(),
                interfaces
            ));
        }
        return result;
    }

    public static function resolveComponentClass(entry:ComponentManifestEntry):Class<Dynamic> {
        return resolveClass(entry.className, "component");
    }

    public static function instantiateIdentifiers(entry:ComponentManifestEntry):Array<IID> {
        var result:Array<IID> = [];
        for (name in entry.interfaces) {
            var iidClass = resolveClass(name, "identifier");
            var value:Dynamic = Type.createInstance(iidClass, []);
            if (!Std.isOfType(value, IID)) {
                throw new haxe.Exception('Identifier class does not implement IID: $name');
            }
            result.push(cast value);
        }
        return result;
    }

    private static function resolveClass(name:String, kind:String):Class<Dynamic> {
        var definition = DefinitionRegistry.resolve(name);
        if (!Std.isOfType(definition, Class)) {
            throw new haxe.Exception('Resolved $kind definition is not a class: $name');
        }
        return cast definition;
    }
}
