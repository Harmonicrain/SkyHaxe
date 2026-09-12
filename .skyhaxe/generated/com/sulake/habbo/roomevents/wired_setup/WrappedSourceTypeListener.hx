package com.sulake.habbo.roomevents.wired_setup
;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;

     class WrappedSourceTypeListener implements ISourceTypeListener
    {
        var _element:DefaultElement;
        var _id:Int = 0;

        public function new(k:DefaultElement, _arg_2:Int)
        {
            this._element = k;
            this._id = _arg_2;
        }

        public var sourceType(never,set):Int;
public function  set_sourceType(k:Int):Int        {
            this._element.roomEvents.wiredCtrl.setMergedSourceType(this._id, k);
return k;
        }
    }

