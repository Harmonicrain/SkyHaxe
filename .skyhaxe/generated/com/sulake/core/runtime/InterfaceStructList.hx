package com.sulake.core.runtime
;
    import com.sulake.core.runtime.IDisposable;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.runtime.*;

    /*internal*/ final class InterfaceStructList implements IDisposable 
    {
        var _list:Array<ASAny>;

        public function new()
        {
            this._list = new Array<ASAny>();
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return this._list.length;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._list == null;
        }

        public function dispose()
        {
var             index:UInt = 0;            index;while (index < (this._list.length : UInt))
            {
                this._list.pop().dispose();
index++;
            }
            this._list = null;
        }

        public function insert(interfaceStruct:InterfaceStruct):UInt
        {
            this._list.push(interfaceStruct);
            return this._list.length;
        }

        public function remove(index:UInt):InterfaceStruct
        {
var interfaceStruct:InterfaceStruct  = null;            if (index < (this._list.length : UInt))
            {
interfaceStruct= this._list[ASCompat.toInt(index)];
                this._list.splice(ASCompat.toInt(index), 1);
                return interfaceStruct;
            }
            throw new ASError("Index out of range!");
        }

        public function find(iid:IID):IUnknown
        {
var             index:UInt = 0, interfaceStruct:InterfaceStruct  = null;            var name= getQualifiedClassName(iid);
            index;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.iis == name)
                {
                    return interfaceStruct.unknown;
                }
index++;
            }
            return null;
        }

        public function getStructByInterface(iid:IID):InterfaceStruct
        {
var             index:UInt = 0, interfaceStruct:InterfaceStruct  = null;            var name= getQualifiedClassName(iid);
            index;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.iis == name)
                {
                    return interfaceStruct;
                }
index++ ;
            }
            return null;
        }

        public function getIndexByInterface(iid:IID):Int
        {
var             index = 0, interfaceStruct:InterfaceStruct  = null;            var name= getQualifiedClassName(iid);
            index;while (index < this._list.length)
            {
interfaceStruct= ASCompat.dynamicAs(this._list[index] , InterfaceStruct);
                if (interfaceStruct.iis == name)
                {
                    return index;
                }
index++;
            }
            return -1;
        }

        public function mapStructsByInterface(iid:IID, out:Array<ASAny>):UInt
        {
var             index:UInt = 0, interfaceStruct:InterfaceStruct  = null;            var name= getQualifiedClassName(iid);
            var count:UInt = 0;
            index;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.iis == name)
                {
                    out.push(interfaceStruct);
                    count++;
                }
index++;
            }
            return count;
        }

        public function getStructByImplementor(unknown:IUnknown):InterfaceStruct
        {
var             index:UInt = 0, interfaceStruct:InterfaceStruct  = null;            index;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.unknown == unknown)
                {
                    return interfaceStruct;
                }
index++;
            }
            return null;
        }

        public function getIndexByImplementor(unknown:IUnknown):Int
        {
var             index:UInt = 0;            var interfaceStruct:InterfaceStruct = null;
            index;while (index < (this._list.length : UInt))
            {
                interfaceStruct = ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.unknown == unknown)
                {
                    return ASCompat.toInt(index);
                }
index++ ;
            }
            return -1;
        }

        public function mapStructsByImplementor(unknown:IUnknown, out:Array<ASAny>):UInt
        {
var             index:UInt  = 0, interfaceStruct:InterfaceStruct  = null;            var count:UInt = 0;
            index= 0;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                if (interfaceStruct.unknown == unknown)
                {
                    out.push(interfaceStruct);
                    count++;
                }
index++;
            }
            return count;
        }

        public function getStructByIndex(index:UInt):InterfaceStruct
        {
            return (index < (this._list.length : UInt)) ? this._list[ASCompat.toInt(index)] : null;
        }

        public function getTotalReferenceCount():UInt
        {
var             index:UInt  = 0, interfaceStruct:InterfaceStruct  = null;            var count:UInt = 0;
            index= 0;while (index < (this._list.length : UInt))
            {
interfaceStruct= ASCompat.dynamicAs(this._list[ASCompat.toInt(index)] , InterfaceStruct);
                count = (count + interfaceStruct.references);
index++ ;
            }
            return count;
        }
    }

