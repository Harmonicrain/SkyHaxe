package com.sulake.core.utils;

class SingleWriteMap extends Map {
    public function new() {
        super();
    }

    override public function setValue(key:Dynamic, value:Dynamic):Void {
        if (hasKey(key)) {
            throw new haxe.Exception('Trying to overwrite value in SingleWriteMap - key: $key, value: $value');
        }
        super.setValue(key, value);
    }
}
