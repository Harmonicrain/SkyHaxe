package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
	/**
	 * ...
	 * @author 
	 */
	 class RoomWidgetVoteMessage extends RoomWidgetMessage
	{
		public static inline final VOTE_MESSAGE= "RWVM_VOTE_MESSAGE";

        var _index:Int = 0;
		
		public function new(index:Int) 
		{
			super(VOTE_MESSAGE);
			this._index = index;
		}
		
        public var index(get,never):Int;
public function  get_index():Int
        {
            return this._index;
        }
	}


