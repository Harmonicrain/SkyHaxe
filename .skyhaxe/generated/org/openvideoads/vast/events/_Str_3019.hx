package org.openvideoads.vast.events
;
    import org.openvideoads.vast.model.NonLinearVideoAd;
    import org.openvideoads.vast.VASTController;

     class _Str_3019 
    {
        var _ad:NonLinearVideoAd = null;
        var _customData:ASObject;
        var _controller:VASTController = null;
        var _width:Int = -1;
        var _height:Int = -1;

        public function new(k:VASTController=null, _arg_2:Int=-1, _arg_3:Int=-1, _arg_4:ASObject=null)
        {
            this._customData = new ASObject();
            this._controller = k;
            this._width = _arg_2;
            this._height = _arg_3;
            if (_arg_4 != null)
            {
                this._customData = _arg_4;
            }
        }

        
        public var controller(get,set):VASTController;
public function  set_controller(k:VASTController):VASTController        {
            return this._controller = k;
        }
public function  get_controller():VASTController
        {
            return this._controller;
        }

        
        public var width(get,set):Int;
public function  set_width(k:Int):Int        {
            return this._width = k;
        }
public function  get_width():Int
        {
            return this._width;
        }

        
        public var height(get,set):Int;
public function  set_height(k:Int):Int        {
            return this._height = k;
        }
public function  get_height():Int
        {
            return this._height;
        }

        public function _Str_19052():Bool
        {
            return !(this._ad == null);
        }

        
        public var ad(get,set):NonLinearVideoAd;
public function  set_ad(k:NonLinearVideoAd):NonLinearVideoAd        {
            return this._ad = k;
        }
public function  get_ad():NonLinearVideoAd
        {
            return this._ad;
        }

        
        public var _Str_3073(get,set):ASObject;
public function  set__Str_3073(k:ASObject):ASObject        {
            return this._customData = k;
        }
public function  get__Str_3073():ASObject
        {
            return this._customData;
        }
    }

