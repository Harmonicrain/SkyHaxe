package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ActivityPointsMessageParser implements IMessageParser 
    {
        var _points:ASDictionary<ASAny,ASAny>;


        public function flush():Bool
        {
            this._points = new ASDictionary<ASAny,ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                this._points[_local_4] = _local_5;
                _local_3++;
            }
            return true;
        }

        public var points(get,never):ASDictionary<ASAny,ASAny>;
public function  get_points():ASDictionary<ASAny,ASAny>
        {
            return this._points;
        }

	public function new() {}
    }

