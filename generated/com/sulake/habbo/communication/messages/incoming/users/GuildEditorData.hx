package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.utils.IVector3d;
    import com.sulake.room.utils.ColorConverter;

     class GuildEditorData 
    {
        var _baseParts:Vector<BadgePartData>;
        var _layerParts:Vector<BadgePartData>;
        var _badgeColors:Vector<GuildColorData>;
        var _guildPrimaryColors:Vector<GuildColorData>;
        var _guildSecondaryColors:Vector<GuildColorData>;

        public function new(k:IMessageDataWrapper=null)
        {
            var _local_2:Int;
            var _local_3:Int;
            this._baseParts = new Vector<BadgePartData>();
            this._layerParts = new Vector<BadgePartData>();
            this._badgeColors = new Vector<GuildColorData>();
            this._guildPrimaryColors = new Vector<GuildColorData>();
            this._guildSecondaryColors = new Vector<GuildColorData>();
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._baseParts.push(new BadgePartData(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._layerParts.push(new BadgePartData(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._badgeColors.push(new GuildColorData(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._guildPrimaryColors.push(new GuildColorData(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._guildSecondaryColors.push(new GuildColorData(k));
                _local_2++;
            }
        }

        public var _Str_11328(get,never):Vector<BadgePartData>;
function  get__Str_11328():Vector<BadgePartData>
        {
            return this._baseParts;
        }

        public var _Str_12125(get,never):Vector<BadgePartData>;
function  get__Str_12125():Vector<BadgePartData>
        {
            return this._layerParts;
        }

        public var _Str_9008(get,never):Vector<GuildColorData>;
function  get__Str_9008():Vector<GuildColorData>
        {
            return this._badgeColors;
        }

        public var _Str_17665(get,never):Vector<GuildColorData>;
function  get__Str_17665():Vector<GuildColorData>
        {
            return this._guildPrimaryColors;
        }

        public var _Str_16298(get,never):Vector<GuildColorData>;
function  get__Str_16298():Vector<GuildColorData>
        {
            return this._guildSecondaryColors;
        }

        public function findMatchingPrimaryColorId(k:Int):Int
        {
            if (((((k < 0) || (this._badgeColors.length <= 0)) || (this._badgeColors.length < k)) || (this._guildPrimaryColors.length <= 0)))
            {
                return 0;
            }
            return this._Str_21273(this._badgeColors[k], this._guildPrimaryColors);
        }

        public function findMatchingSecondaryColorId(k:Int):Int
        {
            if (((((k < 0) || (this._badgeColors.length <= 0)) || (this._badgeColors.length < k)) || (this._guildSecondaryColors.length <= 0)))
            {
                return 0;
            }
            return this._Str_21273(this._badgeColors[k], this._guildSecondaryColors);
        }

        function _Str_21273(k:GuildColorData, _arg_2:Vector<GuildColorData>):Int
        {
            var _local_7:IVector3d;
            var _local_8:Float;
            var _local_3= ColorConverter.rgb2CieLab(k.color);
            var _local_4 = 0;
            var _local_5:Float = ASCompat.MAX_FLOAT;
            var _local_6 = 0;
            while (_local_6 < _arg_2.length)
            {
                _local_7 = ColorConverter.rgb2CieLab(_arg_2[_local_6].color);
                _local_8 = ((Math.pow((_local_3.x - _local_7.x), 2) + Math.pow((_local_3.y - _local_7.y), 2)) + Math.pow((_local_3.z - _local_7.z), 2));
                if (_local_8 < _local_5)
                {
                    _local_5 = _local_8;
                    _local_4 = _local_6;
                }
                _local_6++;
            }
            return _arg_2[_local_4].id;
        }
    }

