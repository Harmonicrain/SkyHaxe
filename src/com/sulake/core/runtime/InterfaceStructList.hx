package com.sulake.core.runtime;

import com.sulake.core.utils.ClassUtils;

class InterfaceStructList implements IDisposable {
    public var length(get, never):Int;
    public var disposed(get, never):Bool;

    private var _list:Null<Array<InterfaceStruct>>;

    public function new() {
        _list = [];
    }

    private inline function items():Array<InterfaceStruct> {
        if (_list == null) {
            throw new haxe.Exception("InterfaceStructList is disposed");
        }
        return _list;
    }

    private inline function get_length():Int {
        return items().length;
    }

    private inline function get_disposed():Bool {
        return _list == null;
    }

    public function dispose():Void {
        if (_list == null) {
            return;
        }
        while (_list.length > 0) {
            _list.pop().dispose();
        }
        _list = null;
    }

    public function insert(interfaceStruct:InterfaceStruct):Int {
        var list = items();
        list.push(interfaceStruct);
        return list.length;
    }

    public function remove(index:Int):InterfaceStruct {
        var list = items();
        if (index < 0 || index >= list.length) {
            throw new haxe.Exception("Index out of range!");
        }
        return list.splice(index, 1)[0];
    }

    public function find(iid:IID):Null<IUnknown> {
        var struct = getStructByInterface(iid);
        return struct == null ? null : struct.unknown;
    }

    public function getStructByInterface(iid:IID):Null<InterfaceStruct> {
        var name = ClassUtils.getQualifiedClassName(iid);
        for (interfaceStruct in items()) {
            if (interfaceStruct.iis == name) {
                return interfaceStruct;
            }
        }
        return null;
    }

    public function getIndexByInterface(iid:IID):Int {
        var name = ClassUtils.getQualifiedClassName(iid);
        var list = items();
        for (index in 0...list.length) {
            if (list[index].iis == name) {
                return index;
            }
        }
        return -1;
    }

    public function mapStructsByInterface(iid:IID, output:Array<InterfaceStruct>):Int {
        var name = ClassUtils.getQualifiedClassName(iid);
        var count = 0;
        for (interfaceStruct in items()) {
            if (interfaceStruct.iis == name) {
                output.push(interfaceStruct);
                count++;
            }
        }
        return count;
    }

    public function getStructByImplementor(unknown:IUnknown):Null<InterfaceStruct> {
        for (interfaceStruct in items()) {
            if (interfaceStruct.unknown == unknown) {
                return interfaceStruct;
            }
        }
        return null;
    }

    public function getIndexByImplementor(unknown:IUnknown):Int {
        var list = items();
        for (index in 0...list.length) {
            if (list[index].unknown == unknown) {
                return index;
            }
        }
        return -1;
    }

    public function mapStructsByImplementor(unknown:IUnknown, output:Array<InterfaceStruct>):Int {
        var count = 0;
        for (interfaceStruct in items()) {
            if (interfaceStruct.unknown == unknown) {
                output.push(interfaceStruct);
                count++;
            }
        }
        return count;
    }

    public function getStructByIndex(index:Int):Null<InterfaceStruct> {
        var list = items();
        return index >= 0 && index < list.length ? list[index] : null;
    }

    public function getTotalReferenceCount():Int {
        var count = 0;
        for (interfaceStruct in items()) {
            count += interfaceStruct.references;
        }
        return count;
    }
}
