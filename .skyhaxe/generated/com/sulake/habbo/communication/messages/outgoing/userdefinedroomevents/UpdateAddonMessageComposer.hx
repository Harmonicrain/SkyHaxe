package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateAddonMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Array<ASAny>, _arg_4:String, _arg_5:Array<ASAny>, _arg_6:Array<ASAny>, _arg_7:Array<ASAny>, _arg_8:Array<ASAny>)
        {
            this._array = [];
            this.appendDefinition(k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8);
        }

        function appendDefinition(k:Int, _arg_2:Array<ASAny>, _arg_3:Array<ASAny>, _arg_4:String, _arg_5:Array<ASAny>, _arg_6:Array<ASAny>, _arg_7:Array<ASAny>, _arg_8:Array<ASAny>)
        {
            this._array.push(k);
            this.appendIntArray(_arg_2);
            this._array.push((_arg_4 != null) ? _arg_4 : "");
            this.appendIntArray(_arg_5);
            this.appendIntArray(_arg_7);
            this.appendIntArray(_arg_8);
            this.appendStringArray(_arg_3);
            this.appendIntArray(_arg_6);
        }

        function appendIntArray(k:Array<ASAny>)
        {
var _local_2 = 0;            if (k == null) { k = []; }
            this._array.push(k.length);
            if (checkNullIteratee(k)) for (_tmp_ in k) { _local_2 = ASCompat.toInt(_tmp_);
this._array.push(_local_2); }
        }

        function appendStringArray(k:Array<ASAny>)
        {
var _local_2:String  = null;            if (k == null) { k = []; }
            this._array.push(k.length);
            if (checkNullIteratee(k)) for (_tmp_ in k) { _local_2 = _tmp_;
this._array.push(_local_2); }
        }

        public function getMessageArray():Array<ASAny> { return this._array; }
        public function dispose() { this._array = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._array == null; }
    }

