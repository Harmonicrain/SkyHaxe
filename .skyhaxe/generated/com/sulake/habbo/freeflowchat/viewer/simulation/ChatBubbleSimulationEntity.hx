package com.sulake.habbo.freeflowchat.viewer.simulation
;
    import com.sulake.habbo.freeflowchat.viewer.visualization.PooledChatBubble;
    import flash.geom.Rectangle;

     class ChatBubbleSimulationEntity 
    {
        public static inline final _Str_13872= 10;

        static inline final _Str_20405= 0.1;
        static inline final _Str_13725= 2500;

        var _visualization:PooledChatBubble;
        var _x:Float = Math.NaN;
        var _y:Float = Math.NaN;
        var _Str_2700:Rectangle;
        var _Str_2864:Rectangle = null;
        var _Str_14799:Float = Math.NaN;
        var _Str_15544:Float = Math.NaN;
        var _Str_12299:Vector<ChatBubbleSimulationEntity>;
        var _isSpacer:Bool = false;

        public function new(k:PooledChatBubble, _arg_2:Bool=false)
        {
            this._Str_2700 = new Rectangle();
            this._Str_12299 = new Vector<ChatBubbleSimulationEntity>(0);
            this._visualization = k;
            var _local_3= k.overlap;
            this._x = (k.x + ((_local_3 != null) ? _local_3.x : 0));
            this._y = (k.y + ((_local_3 != null) ? _local_3.y : 0));
            this._Str_2700.x = this._x;
            this._Str_2700.y = this._y;
            this._Str_2700.width = (this._visualization.width - ((_local_3 != null) ? (_local_3.x + _local_3.width) : 0));
            this._Str_2700.height = ((this._visualization._Str_22234 - _Str_13872) - ((_local_3 != null) ? (_local_3.y + _local_3.height) : 0));
            if (this._visualization.minHeight != -1)
            {
                this._Str_2700.height = this._visualization.minHeight;
            }
            if (_arg_2)
            {
                this._Str_2864 = new Rectangle();
                this._Str_2864.width = (this._Str_2700.width + (2 * ChatBubbleSimulationEntity._Str_13725));
                this._Str_2864.height = ((this._visualization.minHeight != -1) ? this._visualization.minHeight : (this._Str_2700.height / 2));
                this._Str_2864.x = (this._Str_2700.x - ChatBubbleSimulationEntity._Str_13725);
                this._Str_2864.y = this._Str_2700.y;
            }
        }

        public function dispose()
        {
            if (this._visualization != null)
            {
                this._visualization._Str_4702 = true;
            }
            this._visualization = null;
            this._Str_2700 = null;
            this._Str_12299 = null;
            this._Str_2864 = null;
        }

        
        public var y(get,set):Float;
public function  get_y():Float
        {
            return this._y;
        }
public function  set_y(k:Float):Float        {
            this._y = k;
            this._Str_2700.y = this._y;
            if (this._Str_2864 != null)
            {
                this._Str_2864.y = this._Str_2700.y;
            }
return k;
        }

        
        public var x(get,set):Float;
public function  get_x():Float
        {
            return this._x;
        }
public function  set_x(k:Float):Float        {
            this._x = (this._x + ((k - this._x) * (1 - ChatBubbleSimulationEntity._Str_20405)));
            this._Str_2700.x = this._x;
            if (this._Str_2864 != null)
            {
                this._Str_2864.x = (this._Str_2700.x - ChatBubbleSimulationEntity._Str_13725);
            }
return k;
        }

        public var _Str_6163(get,never):Rectangle;
public function  get__Str_6163():Rectangle
        {
            return this._Str_2700;
        }

        public var _Str_10759(get,never):Rectangle;
public function  get__Str_10759():Rectangle
        {
            return (this._Str_2864 != null) ? this._Str_2864 : this._Str_2700;
        }

        public var _Str_20442(get,never):Bool;
public function  get__Str_20442():Bool
        {
            return !(this._Str_2864 == null);
        }

        public var _Str_13971(get,never):Float;
public function  get__Str_13971():Float
        {
            return this._x + (this._Str_2700.width / 2);
        }

        public function initializePosition(k:Float, _arg_2:Float)
        {
            var _local_3= this._visualization.overlap;
            this._x = (k + ((_local_3 != null) ? _local_3.x : 0));
            this._y = (_arg_2 + ((_local_3 != null) ? _local_3.y : 0));
            this._Str_2700.x = this._x;
            this._Str_2700.y = this._y;
            if (this._Str_2864 != null)
            {
                this._Str_2864.x = (this._Str_2700.x - ChatBubbleSimulationEntity._Str_13725);
                this._Str_2864.y = this._Str_2700.y;
            }
        }

        public function _Str_20224(k:Float)
        {
            this._Str_14799 = (this._Str_14799 + k);
        }

        public function _Str_13441(k:ChatBubbleSimulationEntity)
        {
            this._Str_12299.push(k);
        }

        public function _Str_14539(k:ChatBubbleSimulationEntity):Bool
        {
            return !(this._Str_12299.indexOf(k) == -1);
        }

        public function _Str_13455(k:Float)
        {
            this._Str_15544 = (this._Str_15544 + k);
        }

        public function _Str_23082(k:Int)
        {
            this.x = (this.x + this._Str_14799);
            this.y = (this.y + Math.max(this._Str_15544, -k));
        }

        public function _Str_23377()
        {
            this._Str_14799 = 0;
            this._Str_15544 = 0;
            this._Str_12299 = new Vector<ChatBubbleSimulationEntity>(0);
        }

        public function _Str_18740(k:Bool=false)
        {
            var _local_2= this._visualization.overlap;
            if (!k)
            {
                this._visualization.moveTo(Std.int((this._x - ((_local_2 != null) ? _local_2.x : 0))), Std.int((this._y - ((_local_2 != null) ? _local_2.y : 0))));
            }
            else
            {
                this._visualization._Str_12023(Std.int((this._x - ((_local_2 != null) ? _local_2.x : 0))), Std.int((this._y - ((_local_2 != null) ? _local_2.y : 0))));
            }
        }

        public var fullHeightCollision(never,set):Bool;
public function  set_fullHeightCollision(k:Bool):Bool        {
            if (this._Str_2864 != null)
            {
                this._Str_2864.height = (k ? this._Str_2700.height : (this._Str_2700.height / 2));
            }
return k;
        }

        public var _Str_25178(get,never):Bool;
public function  get__Str_25178():Bool
        {
            return this._visualization._Str_19538;
        }

        
        public var _Str_4702(get,set):Bool;
public function  set__Str_4702(k:Bool):Bool        {
            return this._visualization._Str_4702 = k;
        }
public function  get__Str_4702():Bool
        {
            return this._visualization._Str_4702;
        }

        public var timeStamp(get,never):UInt;
public function  get_timeStamp():UInt
        {
            return this._visualization.timeStamp;
        }

        
        public var isSpacer(get,set):Bool;
public function  get_isSpacer():Bool
        {
            return this._isSpacer;
        }
public function  set_isSpacer(k:Bool):Bool        {
            return this._isSpacer = k;
        }

        public function _Str_25372(k:ChatBubbleSimulationEntity):Bool
        {
            if (this._Str_2864 != null)
            {
                return this._Str_2700.intersects(k._Str_2700) || this._Str_2864.intersects(k._Str_10759);
            }
            if (k._Str_2864 != null)
            {
                return this._Str_2700.intersects(k._Str_2700) || this._Str_2700.intersects(k._Str_2864);
            }
            return this._Str_2700.intersects(k._Str_2700);
        }

        public function _Str_23025(k:ChatBubbleSimulationEntity):Bool
        {
            return this._Str_2700.intersects(k._Str_2700);
        }
    }

