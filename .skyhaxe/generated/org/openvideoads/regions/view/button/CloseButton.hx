package org.openvideoads.regions.view.button
;
    import flash.display.Sprite;
    import org.openvideoads.regions.view.RegionView;
    import flash.events.MouseEvent;

     class CloseButton extends Sprite
    {
        var _id:String;
        var _Str_16355:RegionView = null;
        var _Str_16578:Int = 0;
        var _Str_16974:Int = 0;

        public function new(k:String=null, _arg_2:RegionView=null, _arg_3:Int=0, _arg_4:Int=0)
        {
            super();
            this._id = k;
            this._Str_16355 = _arg_2;
            this._Str_16578 = _arg_3;
            this._Str_16974 = _arg_4;
            this.drawButton();
            addEventListener(MouseEvent.ROLL_OVER, (this.onMouseOver : ASAny));
            addEventListener(MouseEvent.ROLL_OUT, (this.onMouseOut : ASAny));
            addEventListener(MouseEvent.CLICK, (this.onMouseClick : ASAny));
            buttonMode = true;
            this.mouseChildren = true;
        }

        
        public var _Str_17906(get,set):Int;
public function  set__Str_17906(k:Int):Int        {
            return this._Str_16578 = k;
        }
public function  get__Str_17906():Int
        {
            return this._Str_16578;
        }

        
        public var _Str_16283(get,set):Int;
public function  set__Str_16283(k:Int):Int        {
            return this._Str_16974 = k;
        }
public function  get__Str_16283():Int
        {
            return this._Str_16974;
        }

        public function calculateLayoutPosition(k:Int, _arg_2:Int)
        {
            x = ((k - this._Str_17906) - (_arg_2 / 5));
            y = ((_arg_2 > 0) ? (this._Str_16283 + (_arg_2 / 5)) : this._Str_16283);
        }

        function drawButton()
        {
        }

        function onMouseOut(k:MouseEvent)
        {
            this.alpha = 0.7;
        }

        function onMouseOver(k:MouseEvent)
        {
            this.alpha = 1;
        }

        function onMouseClick(k:MouseEvent)
        {
            k.stopPropagation();
            if (this._Str_16355 != null)
            {
                this._Str_16355._Str_14359();
            }
        }
    }

