package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.IUserDefinedRoomEventsCtrl;
    import com.sulake.habbo.roomevents.userdefinedroomevents.WiredFurniture;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.ActionDefinition;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
	import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.CallAnotherStack;

     class ActionTypes implements IUserDefinedRoomEventsCtrl 
    {
        var _types:Array<ASAny>;

        public function new()
        {
            this._types = new Array<ASAny>();
            this._types.push(new ToggleFurniState());
            this._types.push(new Reset());
            this._types.push(new SetFurniStateTo());
            this._types.push(new MoveFurni());
            this._types.push(new GiveScore());
            this._types.push(new Chat());
            this._types.push(new Teleport());
            this._types.push(new JoinTeam());
            this._types.push(new LeaveTeam());
            this._types.push(new Chase());
            this._types.push(new Flee());
            this._types.push(new MoveToDirection());
            this._types.push(new GiveScoreToPredefinedTeam());
            this._types.push(new ToggleToRandomState());
            this._types.push(new MoveFurniTo());
            this._types.push(new GiveReward());
            this._types.push(new CallAnotherStack());
            this._types.push(new KickFromRoom());
            this._types.push(new MuteUser());
            this._types.push(new BotTeleport());
            this._types.push(new BotMove());
            this._types.push(new BotTalk());
            this._types.push(new BotGiveHandItem());
            this._types.push(new BotFollowAvatar());
            this._types.push(new BotChangeFigure());
            this._types.push(new BotTalkDirectToAvatar());
        }

        public var _Str_24294(get,never):Array<ASAny>;
public function  get__Str_24294():Array<ASAny>
        {
            return this._types;
        }

        public function _Str_9781(k:Int):DefaultActionType
        {
            var _local_2:DefaultActionType = null;
            final _iter_ = this._types; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.code == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_15652(k:Int):WiredFurniture
        {
            return this._Str_9781(k);
        }

        public function _Str_14545(k:Triggerable):Bool
        {
            return !(Std.downcast(k , ActionDefinition) == null);
        }

        public function _Str_1196():String
        {
            return "action";
        }
    }

