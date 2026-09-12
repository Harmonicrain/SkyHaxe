package com.sulake.habbo.communication.messages.outgoing.roomsettings
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class SaveRoomSettingsMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var messageArray:Array<ASAny>;

        public function new(k:SaveableRoomSettingsData)
        {
            var tags:Array<ASAny> = null;
            var _local_3:String = null;
            var _local_4:String = null;
            this.messageArray = new Array<ASAny>();
            this.messageArray.push(k.roomId);
            this.messageArray.push(k.name);
            this.messageArray.push(k.description);
            this.messageArray.push(k.doorMode);
            this.messageArray.push(((k.password != null) ? k.password : ""));
            this.messageArray.push(k.maximumVisitors);
            this.messageArray.push(k.categoryId);
            if (k.tags != null)
            {
                tags = [];
                final _iter_ = k.tags; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    if ((ASCompat.stringAsBool(_local_3) && (!(_local_3 == ""))))
                    {
                        tags.push(_local_3);
                    }
                }
                this.messageArray.push(tags.length);
                if (checkNullIteratee(tags)) for (_tmp_ in tags)
                {
_local_4  = _tmp_;
                    this.messageArray.push(_local_4);
                }
            }
            else
            {
                this.messageArray.push(0);
            }
            this.messageArray.push(k.tradeMode);
            this.messageArray.push(k.allowPets);
            this.messageArray.push(k.allowFoodConsume);
            this.messageArray.push(k.allowWalkThrough);
            this.messageArray.push(k.hideWalls);
            this.messageArray.push(k.wallThickness);
            this.messageArray.push(k.floorThickness);
            this.messageArray.push(k.whoCanMute);
            this.messageArray.push(k.whoCanKick);
            this.messageArray.push(k.whoCanBan);
            this.messageArray.push(k.chatMode);
            this.messageArray.push(k.chatBubbleSize);
            this.messageArray.push(k.chatScrollUpFrequency);
            this.messageArray.push(k.chatFullHearRange);
            this.messageArray.push(k.chatFloodSensitivity);
            this.messageArray.push(k.allowNavigatorDynCats);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this.messageArray;
        }

        public function dispose()
        {
            this.messageArray = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

