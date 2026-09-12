package com.sulake.habbo.ui.handler
;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.IRoomWidgetHandlerContainer;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.session.IRoomSession;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.ui.widget.events.RoomWidgetWordQuizUpdateEvent;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetMessage;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;
    import com.sulake.habbo.session.events.RoomSessionWordQuizEvent;
    import com.sulake.habbo.session.RoomUserData;
    import com.sulake.habbo.avatar._enum.AvatarAction;
    import flash.events.Event;

     class WordQuizWidgetHandler implements IRoomWidgetHandler 
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
            return RoomWidgetEnum.WORD_QUIZZ;
        }

        
        public var container(get,set):IRoomWidgetHandlerContainer;
public function  set_container(k:IRoomWidgetHandlerContainer):IRoomWidgetHandlerContainer        {
            return this._container = k;
        }

        public function dispose()
        {
            this._disposed = true;
            this._container = null;
        }
public function  get_container():IRoomWidgetHandlerContainer
        {
            return this._container;
        }

        public var roomSession(get,never):IRoomSession;
public function  get_roomSession():IRoomSession
        {
            return (this._container != null) ? this._container.roomSession : null;
        }

        public var roomEngine(get,never):IRoomEngine;
public function  get_roomEngine():IRoomEngine
        {
            return (this._container != null) ? this._container.roomEngine : null;
        }

        public function getWidgetMessages():Array<ASAny>
        {
            return [RoomWidgetWordQuizUpdateEvent.RWPUW_QUESTION_ANSWERED, RoomWidgetWordQuizUpdateEvent.RWPUW_QUESION_FINSIHED, RoomWidgetWordQuizUpdateEvent.RWPUW_NEW_QUESTION];
        }

        public function processWidgetMessage(k:RoomWidgetMessage):RoomWidgetUpdateEvent
        {
            return null;
        }

        public function getProcessedEvents():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            k.push(RoomSessionWordQuizEvent.RWPUW_QUESTION_ANSWERED);
            k.push(RoomSessionWordQuizEvent.RWPUW_QUESION_FINSIHED);
            k.push(RoomSessionWordQuizEvent.RWPUW_NEW_QUESTION);
            return k;
        }

        public function processEvent(k:Event)
        {
            var _local_2:RoomSessionWordQuizEvent = null;
            var _local_3:RoomWidgetWordQuizUpdateEvent = null;
            var _local_4:RoomUserData = null;
            if ((((this._container == null) || (this._container.events == null)) || (this._container.roomSession == null)))
            {
                return;
            }
            _local_2 = Std.downcast(k , RoomSessionWordQuizEvent);
            if (_local_2 == null)
            {
                return;
            }
            switch (k.type)
            {
                case RoomSessionWordQuizEvent.RWPUW_QUESTION_ANSWERED:
                    _local_3 = new RoomWidgetWordQuizUpdateEvent(_local_2.id, RoomWidgetWordQuizUpdateEvent.RWPUW_QUESTION_ANSWERED);
                    _local_3.value = _local_2.value;
                    _local_3.userId = _local_2.userId;
                    _local_3.answerCounts = _local_2.answerCounts;
                    _local_4 = this._container.roomSession.userDataManager.getUserData(_local_2.userId);
                    if (_local_4 == null)
                    {
                        return;
                    }
                    if (_local_3.value == "0")
                    {
                        this._container.roomEngine.updateObjectUserGesture(this._container.roomSession.roomId, _local_4.roomObjectId, AvatarAction.getGestureId(AvatarAction.GESTURE_SAD));
                    }
                    else
                    {
                        this._container.roomEngine.updateObjectUserGesture(this._container.roomSession.roomId, _local_4.roomObjectId, AvatarAction.getGestureId(AvatarAction.GESTURE_SMILE));
                    }
                    
                case RoomSessionWordQuizEvent.RWPUW_QUESION_FINSIHED:
                    _local_3 = new RoomWidgetWordQuizUpdateEvent(_local_2.id, RoomWidgetWordQuizUpdateEvent.RWPUW_QUESION_FINSIHED);
                    _local_3.pollId = _local_2.pollId;
                    _local_3.questionId = _local_2.questionId;
                    _local_3.answerCounts = _local_2.answerCounts;
                    
                case RoomSessionWordQuizEvent.RWPUW_NEW_QUESTION:
                    _local_3 = new RoomWidgetWordQuizUpdateEvent(_local_2.id, RoomWidgetWordQuizUpdateEvent.RWPUW_NEW_QUESTION);
                    _local_3.question = _local_2.question;
                    _local_3.duration = _local_2.duration;
                    _local_3.pollType = _local_2.pollType;
                    _local_3.questionId = _local_2.questionId;
                    _local_3.pollId = _local_2.pollId;
                    
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

