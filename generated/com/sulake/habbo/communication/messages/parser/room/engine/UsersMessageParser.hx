package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.engine.UserMessageData;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UsersMessageParser implements IMessageParser 
    {
        var _users:Array<ASAny>;

        public function new()
        {
            this._users = [];
        }

        public static function convertOldPetFigure(k:String):String
        {
            var _local_8:Int;
            var _local_9:Int;
            var _local_2:Array<ASAny> = ["FF7B3A", "FF9763", "FFCDB3", "F59500", "FBBD5C", "FEE4B2", "EDD400", "F5E759", "FBF8B1", "84A95F", "B0C993", "DBEFC7", "65B197", "91C7B5", "C5EDDE", "7F89B2", "98A1C5", "CAD2EC", "A47FB8", "C09ED5", "DBC7E9", "BD7E9D", "DA9DBD", "ECC6DB", "DD7B7D", "F08B90", "F9BABF", "ABABAB", "D4D4D4", "FFFFFF", "D98961", "DFA281", "F1D2C2", "D5B35F", "DAC480", "FCFAD3", "EAA7AF", "86BC40", "E8CE25", "8E8839", "888F67", "5E9414", "84CE84", "96E75A", "88E70D", "B99105", "C8D71D", "838851", "C08337", "83A785", "E6AF26", "ECFF99", "94FFF9", "ABC8E5", "F2E5CC", "D2FF00"];
            var _local_3:Array<ASAny> = (cast k.split(" "));
            if (_local_3.length < 3)
            {
                return "";
            }
            var _local_4= ASCompat.toInt(_local_3[0]);
            var _local_5= (ASCompat.toInt(_local_3[1]) + 1);
            var _local_6= ASCompat.toString(_local_3[2]);
            _local_6 = _local_6.substr((_local_6.length - 6), 6);
            var _local_7= 25;
            if (_local_4 <= 1)
            {
                _local_8 = ((_local_7 * _local_4) + _local_5);
            }
            else
            {
                _local_8 = 64;
            }
            _local_9 = (_local_2.indexOf(_local_6.toUpperCase()) + 1);
            var _local_10= "";
            _local_10 = (_local_10 + ((("phd-" + _local_8) + "-") + _local_9));
            _local_10 = (_local_10 + (((".pbd-" + _local_8) + "-") + _local_9));
            _local_10 = (_local_10 + (((".ptl-" + _local_8) + "-") + _local_9));
            return _local_10;
        }


        public function flush():Bool
        {
            this._users = [];
            return true;
        }

        public function getUserCount():Int
        {
            return this._users.length;
        }

        public function getUser(k:Int):UserMessageData
        {
            if (((k < 0) || (k >= this.getUserCount())))
            {
                return null;
            }
            var _local_2= ASCompat.dynamicAs(this._users[k] , UserMessageData);
            if (_local_2 != null)
            {
                _local_2.setReadOnly();
            }
            return _local_2;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var id:Int;
            var name:String;
            var custom:String;
            var figure:String;
            var index:Int;
            var x:Int;
            var y:Int;
            var z:String;
            var dir:Int;
            var type:Int;
            var userMessageData:UserMessageData;
            var _local_15:String;
            var botSkillsAmount:Int;
            var botSkills:Array<ASAny>;
            var currentBotSkill:Int;
            this._users = [];
            var usersAmount= k.readInteger();
            var currentUser = 0;
            while (currentUser < usersAmount)
            {
                id = k.readInteger();
                name = k.readString();
                custom = k.readString();
                figure = k.readString();
                index = k.readInteger();
                x = k.readInteger();
                y = k.readInteger();
                z = k.readString();
                dir = k.readInteger();
                type = k.readInteger();
                userMessageData = new UserMessageData(index);
                userMessageData.dir = dir;
                userMessageData.name = name;
                userMessageData.custom = custom;
                userMessageData.x = x;
                userMessageData.y = y;
                userMessageData.z = ASCompat.toNumber(z);
                this._users.push(userMessageData);
                if (type == 1)
                {
                    userMessageData.id = id;
                    userMessageData.userType = RoomObjectTypeEnum.HABBO;
                    userMessageData.sex = this.resolveSex(k.readString());
                    userMessageData.groupID = ("" + k.readInteger());
                    userMessageData.groupStatus = k.readInteger();
                    userMessageData.groupName = k.readString();
                    _local_15 = k.readString();
                    if (_local_15 != "")
                    {
                        figure = this.convertSwimFigure(_local_15, figure, userMessageData.sex);
                    }
                    userMessageData.figure = figure;
                    userMessageData.activityPoints = k.readInteger();
                    userMessageData.isModerator = k.readBoolean();
                }
                else
                {
                    if (type == 2)
                    {
                        userMessageData.userType = RoomObjectTypeEnum.PET;
                        userMessageData.figure = figure;
                        userMessageData.id = id;
                        userMessageData.subType = Std.string(k.readInteger());
                        userMessageData.ownerId = k.readInteger();
                        userMessageData.ownerName = k.readString();
                        userMessageData.rarityLevel = k.readInteger();
                        userMessageData.hasSaddle = k.readBoolean();
                        userMessageData.isRiding = k.readBoolean();
                        userMessageData.canBreed = k.readBoolean();
                        userMessageData.canHarvest = k.readBoolean();
                        userMessageData.canRevive = k.readBoolean();
                        userMessageData.hasBreedingPermission = k.readBoolean();
                        userMessageData.petLevel = k.readInteger();
                        userMessageData.petPosture = k.readString();
                    }
                    else
                    {
                        if (type == 3)
                        {
                            userMessageData.userType = RoomObjectTypeEnum.BOT;
                            userMessageData.id = (index * -1);
                            if (figure.indexOf("/") == -1)
                            {
                                userMessageData.figure = figure;
                            }
                            else
                            {
                                userMessageData.figure = "hr-100-.hd-180-1.ch-876-66.lg-270-94.sh-300-64";
                            }
                            userMessageData.sex = UserMessageData.USER_SEX_MALE;
                        }
                        else
                        {
                            if (type == 4)
                            {
                                userMessageData.userType = RoomObjectTypeEnum.RENTABLE_BOT;
                                userMessageData.id = id;
                                userMessageData.sex = this.resolveSex(k.readString());
                                userMessageData.figure = figure;
                                userMessageData.ownerId = k.readInteger();
                                userMessageData.ownerName = k.readString();
                                botSkillsAmount = k.readInteger();
                                if (botSkillsAmount > 0)
                                {
                                    botSkills = new Array<ASAny>();
                                    currentBotSkill = 0;
                                    while (currentBotSkill < botSkillsAmount)
                                    {
                                        botSkills.push(k.readShort());
                                        currentBotSkill++;
                                    }
                                    userMessageData.botSkills = botSkills;
                                }
                            }
                        }
                    }
                }
                currentUser++;
            }
            return true;
        }

        function resolveSex(k:String):String
        {
            if (k.substr(0, 1).toLowerCase() == "f")
            {
                return UserMessageData.USER_SEX_FEMALE;
            }
            return UserMessageData.USER_SEX_MALE;
        }

        function convertSwimFigure(k:String, _arg_2:String, _arg_3:String):String
        {
            var _local_13:String;
            var _local_14:Array<ASAny>;
            var _local_15:String;
            var _local_16:Array<ASAny>;
            var _local_17:String;
            var _local_18:String;
            var _local_19:Int;
            var _local_4:Array<ASAny> = (cast _arg_2.split("."));
            var _local_5= 1;
            var _local_6= 1;
            var _local_7= 1;
            var _local_8:ASAny = 10000;
            var _local_9 = 0;
            while (_local_9 < _local_4.length)
            {
                _local_13 = _local_4[_local_9];
                _local_14 = (cast _local_13.split("-"));
                if (_local_14.length > 2)
                {
                    _local_15 = _local_14[0];
                    if (_local_15 == "hd")
                    {
                        _local_5 = ASCompat.toInt(_local_14[2]);
                    }
                }
                _local_9++;
            }
            var _local_10:Array<ASAny> = ["238,238,238", "250,56,49", "253,146,160", "42,199,210", "53,51,44", "239,255,146", "198,255,152", "255,146,90", "157,89,126", "182,243,255", "109,255,51", "51,120,201", "255,182,49", "223,161,233", "249,251,50", "202,175,143", "197,198,197", "71,98,61", "138,131,97", "255,140,51", "84,198,39", "30,108,153", "152,79,136", "119,200,255", "255,192,142", "60,75,135", "124,44,71", "215,255,227", "143,63,28", "255,99,147", "31,155,121", "253,255,51"];
            var _local_11:Array<ASAny> = (cast k.split("="));
            if (_local_11.length > 1)
            {
                _local_16 = (cast ASCompat.toString(_local_11[1] ).split("/"));
                _local_17 = _local_16[0];
                _local_18 = _local_16[1];
                if (_arg_3 == "F")
                {
                    _local_7 = 10010;
                }
                else
                {
                    _local_7 = 10011;
                }
                _local_19 = _local_10.indexOf(_local_18);
                _local_6 = ASCompat.toInt((_local_8 + _local_19) + 1);
            }
            var _local_12= (((((".bds-10001-" + _local_5) + ".ss-") + _local_7) + "-") + _local_6);
            return _arg_2 + _local_12;
        }
    }

