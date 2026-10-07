package org.openvideoads.vast.overlay.button.skip
;
    import org.openvideoads.vast.overlay.OverlayView;
    import org.openvideoads.regions.RegionController;
    import org.openvideoads.regions.config.RegionViewConfig;
    import org.openvideoads.util.Display;
    import flash.events.MouseEvent;

     class _Str_8718 extends OverlayView 
    {
        var _Str_7282:ASFunction = null;
        var _active:Bool = false;

        public function new(k:RegionController, _arg_2:RegionViewConfig, _arg_3:Display, _arg_4:Int=-1, _arg_5:Int=-1)
        {
            super(k, _arg_2, _arg_3);
            if (_arg_2._Str_24560())
            {
                if ((_arg_2._Str_24467() || _arg_2._Str_23156()))
                {
                    this.alpha = 0.8;
                    this.addChild(_arg_2.image);
                }
            }
            else
            {
                if (_arg_2._Str_23612())
                {
                }
            }
        }

        public function _Str_23238(k:ASFunction)
        {
            this._Str_7282 = k;
        }

        override function onMouseOver(k:MouseEvent)
        {
            this.alpha = 1;
        }

        override function onMouseOut(k:MouseEvent)
        {
            this.alpha = 0.8;
        }

        override function onClick(k:MouseEvent)
        {
            if (this._Str_7282 != null)
            {
                this._Str_7282();
            }
        }

        public var active(get,never):Bool;
public function  get_active():Bool
        {
            return this._active;
        }

        public function activate()
        {
            this._active = true;
            show();
        }

        public function deactivate()
        {
            this._active = false;
            hide();
        }
    }

