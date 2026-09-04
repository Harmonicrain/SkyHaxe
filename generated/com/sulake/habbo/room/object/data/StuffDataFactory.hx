package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;

     class StuffDataFactory 
    {
        public static function getStuffDataWrapperForType(type:Int):IStuffData
        {
            var stuffData:IStuffData = null;
            switch (type & 0xFF)
            {
                case LegacyStuffData.FORMAT_KEY: //0
                    stuffData = new LegacyStuffData() ;
                    
                case MapStuffData.FORMAT_KEY: //1
                    stuffData = new MapStuffData() ;
                    
                case StringArrayStuffData.FORMAT_KEY: //2
                    stuffData = new StringArrayStuffData() ;
                    
                case VoteResultStuffData.FORMAT_KEY: //3
                    stuffData = new VoteResultStuffData() ;
                    
                case StuffDataFormatKeyEnum.EMPTY_TYPE_KEY: //4
                    stuffData = new EmptyStuffData() ;
                    
                case StuffDataFormatKeyEnum.INT_ARRAY_TYPE_KEY: //5
                    stuffData = new IntArrayStuffData() ;
                    
                case StuffDataFormatKeyEnum.HIGH_SCORE_TYPE_KEY: //6
                    stuffData = new HighScoreStuffData() ;
                    
                case StuffDataFormatKeyEnum.CRACKABLE_TYPE_KEY: //7
                    stuffData = new CrackableStuffData() ;
                    
            }
            if (stuffData != null)
            {
                stuffData.flags = (type & 0xFF00);
            }
            return stuffData;
        }

	public function new() {}
    }

