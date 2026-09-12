package com.sulake.habbo.sound.trax
;
    import com.sulake.core.utils.Map;

     class TraxData 
    {
        var _channels:Array<ASAny>;
        var _metaData:Map;

        public function new(k:String)
        {
            var channelLines:Array<ASAny> = null;
            var metaDatas:Array<ASAny> = null;
            var m = 0;
            var metaDataKey:String = null;
            var metaDataValue:String = null;
            var channelId = 0;
            var channelItemSets:Array<ASAny> = null;
            var channel:TraxChannel = null;
            var i = 0;
            var channelItem:Array<ASAny> = null;
            var channelItemId = 0;
            var channelItemLength = 0;
            this._metaData = new Map();
            this._channels = [];
            var lines:Array<ASAny> = (cast k.split(":"));
            var lastLine= ASCompat.toString(lines[(lines.length - 1)]);
            if (lastLine.indexOf("meta") != -1)
            {
                metaDatas = (cast lastLine.split(";"));
                m = 0;
                while (m < metaDatas.length)
                {
                    metaDataKey = ASCompat.toString(metaDatas[m]).split(",")[0];
                    metaDataValue = ASCompat.toString(metaDatas[m]).split(",")[1];
                    this._metaData.add(metaDataKey, metaDataValue);
                    m++;
                }
                channelLines = lines.slice(0, (lines.length - 1));
            }
            else
            {
                channelLines = lines;
            }
            var c = 0;
            while (c < (channelLines.length / 2))
            {
                if (Std.string(channelLines[(c * 2)]).length > 0)
                {
                    channelId = ASCompat.toInt(channelLines[(c * 2)]);
                    channelItemSets = Std.string(channelLines[((c * 2) + 1)]).split(";");
                    channel = new TraxChannel(channelId);
                    i = 0;
                    while (i < channelItemSets.length)
                    {
                        channelItem = Std.string(channelItemSets[i]).split(",");
                        if (channelItem.length != 2)
                        {
                            Logger.log(["Trax load error: invalid song data string"]);
                            return;
                        }
                        channelItemId = ASCompat.toInt(channelItem[0]);
                        channelItemLength = ASCompat.toInt(channelItem[1]);
                        channel.addChannelItem(new TraxChannelItem(channelItemId, channelItemLength));
                        i++;
                    }
                    this._channels.push(channel);
                }
                c++;
            }
        }

        public var channels(get,never):Array<ASAny>;
public function  get_channels():Array<ASAny>
        {
            return this._channels;
        }

        public function getSampleIds():Array<ASAny>
        {
            var _local_3:TraxChannel = null;
            var _local_4 = 0;
            var _local_5:TraxChannelItem = null;
            var k:Array<ASAny> = [];
            var _local_2 = 0;
            while (_local_2 < this._channels.length)
            {
                _local_3 = ASCompat.dynamicAs(this._channels[_local_2] , TraxChannel);
                _local_4 = 0;
                while (_local_4 < _local_3.itemCount)
                {
                    _local_5 = _local_3.getItem(_local_4);
                    if (k.indexOf(_local_5.id) == -1)
                    {
                        k.push(_local_5.id);
                    }
                    _local_4++;
                }
                _local_2++;
            }
            return k;
        }

        public var hasMetaData(get,never):Bool;
public function  get_hasMetaData():Bool
        {
            return !(this._metaData.getValue("meta")== null);
        }

        public var metaCutMode(get,never):Bool;
public function  get_metaCutMode():Bool
        {
            return this._metaData.getValue("c")== "1";
        }

        public var metaTempo(get,never):Int;
public function  get_metaTempo():Int
        {
            return ASCompat.asInt(this._metaData.getValue("t"));
        }
    }

