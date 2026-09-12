package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateSelectorMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:String, _arg_4:Array<ASAny>, _arg_5:Bool, _arg_6:Bool, _arg_7:Array<ASAny> = null, _arg_8:Array<ASAny> = null, _arg_9:Array<ASAny> = null, _arg_10:Array<ASAny> = null)
        {
            var _i = 0;
            var _s:String = null;
            this._array = new Array<ASAny>();
            if (_arg_7 == null) { _arg_7 = []; }
            if (_arg_8 == null) { _arg_8 = []; }
            if (_arg_9 == null) { _arg_9 = []; }
            if (_arg_10 == null) { _arg_10 = []; }
            this._array.push(k);
            this._array.push(_arg_2.length);
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_3);
            this._array.push(_arg_4.length);
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_5);
            this._array.push(_arg_6);
            this._array.push(_arg_7.length);
            if (checkNullIteratee(_arg_7)) for (_tmp_ in _arg_7) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_8.length);
            if (checkNullIteratee(_arg_8)) for (_tmp_ in _arg_8) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_9.length);
            if (checkNullIteratee(_arg_9)) for (_tmp_ in _arg_9) { _s  = _tmp_;
this._array.push(_s); }
            this._array.push(_arg_10.length);
            if (checkNullIteratee(_arg_10)) for (_tmp_ in _arg_10) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

