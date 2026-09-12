package com.sulake.habbo.roomevents.wired_setup.uibuilder.params
;
    /**
     * Source-type selector descriptor. The listener remains untyped because the
     * clean-client picker implementations expose different callback interfaces.
     */
     class SourceTypeSelectorParam
    {
        var _ids:Array<ASAny>;
        var _currentSelection:Int = 0;
        var _listener:ASObject;

        public function new(_arg_1:Array<ASAny>, _arg_2:ASObject, _arg_3:Int = 0)
        {
            this._ids = _arg_1;
            this._currentSelection = _arg_3;
            this._listener = _arg_2;
        }

        public var ids(get,never):Array<ASAny>;
public function  get_ids():Array<ASAny> { return this._ids; }
        public var currentSelection(get,never):Int;
public function  get_currentSelection():Int { return this._currentSelection; }
        public var listener(get,never):ASObject;
public function  get_listener():ASObject { return this._listener; }
    }

