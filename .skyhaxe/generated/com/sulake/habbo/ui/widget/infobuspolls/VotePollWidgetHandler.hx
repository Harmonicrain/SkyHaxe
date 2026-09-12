package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.habbo.ui.widget.events.RoomWidgetVoteUpdateEvent;
	import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
	import com.sulake.habbo.ui.IRoomWidgetHandler;
	import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
	import com.sulake.habbo.session.events.RoomSessionVoteEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	 class VotePollWidgetHandler implements IRoomWidgetHandler
	{
		var _disposed:Bool = false;
		var _container:IRoomWidgetHandlerContainer = null;

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return RoomWidgetEnum.ROOM_VOTE;
        }

        public var container(never,set):IRoomWidgetHandlerContainer;
public function  set_container(_arg_1:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = _arg_1;
        }

        public function dispose()
        {
            this._disposed = true;
            this._container = null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetVoteMessage.VOTE_MESSAGE];
        }

        public function processWidgetMessage(_arg_1:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            var _local_2:RoomWidgetVoteMessage = null;
            switch (_arg_1.type)
            {
                case RoomWidgetVoteMessage.VOTE_MESSAGE:
                    _local_2 = Std.downcast(_arg_1 , RoomWidgetVoteMessage);
                    if (_local_2 == null)
                    {
                        return null;
                    }
                    this._container.roomSession.votePoll(_local_2.index);
                    
            }
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var _local_1:Array<ASAny> = [];
            _local_1.push(RoomSessionVoteEvent.VOTE_QUESTION);
            _local_1.push(RoomSessionVoteEvent.VOTE_RESULT);
            return _local_1;
        }

        public function processEvent(_arg_1:Event)
        {
            var _local_3:RoomWidgetVoteUpdateEvent = null;
            if (((this._container == null) || (this._container.events == null)))
            {
                return;
            }
            var _local_2= Std.downcast(_arg_1 , RoomSessionVoteEvent);
            if (_local_2 == null)
            {
                return;
            }
            switch (_arg_1.type)
            {
                case RoomSessionVoteEvent.VOTE_QUESTION:
                    _local_3 = new RoomWidgetVoteUpdateEvent(RoomWidgetVoteUpdateEvent.VOTE_QUESTION, _local_2.question, _local_2.choices);
                    
                case RoomSessionVoteEvent.VOTE_RESULT:
                    _local_3 = new RoomWidgetVoteUpdateEvent(RoomWidgetVoteUpdateEvent.VOTE_RESULT, _local_2.question, _local_2.choices, _local_2._SafeStr_4173, _local_2._SafeStr_4174);
                    
            }
            if (_local_3 == null)
            {
                return;
            }
            this._container.events.dispatchEvent(_local_3);
        }

        public function update()
        {
        }
public function new(){}
	}


