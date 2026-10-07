package com.sulake.habbo.freeflowchat.viewer.simulation
;
    import com.sulake.habbo.freeflowchat.viewer._enum.ChatBubbleWidth;
    import flash.geom.Rectangle;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;

     class ChatBubbleSimulationWithLimitedWideRect extends ChatBubbleSimulationEntity 
    {
        public static final _Str_13155:Int = ChatBubbleWidth.THIN;//240

        var _wideRectOffset:Float = Math.NaN;

        public function new(k:PooledChatBubble)
        {
            super(k, false);
            _Str_2864 = new Rectangle();
            _Str_2864.width = _Str_13155;
            _Str_2864.height = (_Str_2700.height / 2);
            this._wideRectOffset = (-(_Str_13155 - _Str_2700.width) / 2);
            _Str_2864.x = (_Str_2700.x + this._wideRectOffset);
            _Str_2864.y = _Str_2700.y;
        }

        override public function  set_x(k:Float):Float        {
            _x = (_x + ((k - _x) * (1 - ChatBubbleSimulationEntity._Str_20405)));
            _Str_2700.x = _x;
            if (_Str_2864 != null)
            {
                _Str_2864.x = (_Str_2700.x + this._wideRectOffset);
            }
return k;
        }

        override public function initializePosition(k:Float, _arg_2:Float)
        {
            var _local_3:Rectangle = null;
            _local_3 = _visualization.overlap;
            _x = (k + ((_local_3 != null) ? _local_3.x : 0));
            _y = (_arg_2 + ((_local_3 != null) ? _local_3.y : 0));
            _Str_2700.x = _x;
            _Str_2700.y = _y;
            if (_Str_2864 != null)
            {
                _Str_2864.x = (_Str_2700.x + this._wideRectOffset);
                _Str_2864.y = _Str_2700.y;
            }
        }

        
        public var _Str_5036(get,set):Float;
public function  get__Str_5036():Float
        {
            return this._wideRectOffset;
        }
public function  set__Str_5036(k:Float):Float        {
            return this._wideRectOffset = k;
        }
    }

