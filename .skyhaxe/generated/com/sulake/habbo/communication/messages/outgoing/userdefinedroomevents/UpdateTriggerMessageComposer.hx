package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    // Wired 2.0 save format. Old callers can omit source/variable/stuffIds2 arrays.
     class UpdateTriggerMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:String, _arg_4:Array<ASAny>, _arg_5:Int, _arg_6:Array<ASAny> = null, _arg_7:Array<ASAny> = null, _arg_8:Array<ASAny> = null, _arg_9:Array<ASAny> = null)
        {
            var _i = 0;
            var _s:String = null;
            this._array = new Array<ASAny>();
            if (_arg_6 == null) { _arg_6 = []; }
            if (_arg_7 == null) { _arg_7 = []; }
            if (_arg_8 == null) { _arg_8 = []; }
            if (_arg_9 == null) { _arg_9 = []; }
            this._array.push(k);                       // id
            this._array.push(_arg_2.length);           // intParams
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_3);                  // stringParam
            this._array.push(_arg_4.length);           // stuffIds
            if (checkNullIteratee(_arg_4)) for (_tmp_ in _arg_4) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            // (trigger: no type-specific field)
            this._array.push(_arg_6.length);           // furniSourceTypes
            if (checkNullIteratee(_arg_6)) for (_tmp_ in _arg_6) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_7.length);           // userSourceTypes
            if (checkNullIteratee(_arg_7)) for (_tmp_ in _arg_7) { _i  = ASCompat.toInt(_tmp_);
this._array.push(_i); }
            this._array.push(_arg_8.length);           // variableIds
            if (checkNullIteratee(_arg_8)) for (_tmp_ in _arg_8) { _s  = _tmp_;
this._array.push(_s); }
            this._array.push(_arg_9.length);           // stuffIds2
            if (checkNullIteratee(_arg_9)) for (_tmp_ in _arg_9) { _i  = ASCompat.toInt(_tmp_);
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

