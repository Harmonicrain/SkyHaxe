package org.openvideoads.vast.model
;
    import org.openvideoads.regions.view._Str_4027;

     class _Str_4713 extends NonLinearVideoAd implements _Str_4027 
    {


        public function signalLoadError(k:String)
        {
        }

        public var _Str_12737(get,never):String;
public function  get__Str_12737():String
        {
            if (_Str_3937())
            {
                return _Str_3366;
            }
            return _Str_577.getQualifiedStreamAddress();
        }

        override public function  get_content():String
        {
            return this._Str_12737;
        }

        public function shouldMaintainAspectRatio():Bool
        {
            return this.maintainAspectRatio;
        }

        public var recommendedWidth(get,never):Int;
public function  get_recommendedWidth():Int
        {
            return _width;
        }

        public var recommendedHeight(get,never):Int;
public function  get_recommendedHeight():Int
        {
            return _height;
        }

        override public function clicked()
        {
            if (!isInteractive())
            {
                super.clicked();
            }
        }

        override public function close()
        {
            super.close();
        }

	public function new() { super(); }
    }

