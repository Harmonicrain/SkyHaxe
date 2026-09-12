package com.sulake.habbo.snowstorm
;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.avatar._enum.AvatarFigurePartType;

    /** Pure arena-only implementation of the r26 fixSnowWarFigure colour/part selection. */
     final class SnowStormUniformFigure
    {
        public static inline final FALLBACK_COLOUR:UInt = 0xEEEEEE;
        public static final TEAM_COLOURS:Array<ASAny> = [0xFF5136, 0x29C2FF, 0xFFDD36, 0xED28FF];

        static final HEAD_TYPES:ASObject = {
            "hd": true,
            "hr": true,
            "fa": true,
            "ea": true,
            "ha": true,
            "he": true
        };

        /**
         * The original SnowStorm avatar starts from human.partset.head.sh and adds only bd/sh. AIR's
         * figure renderer can therefore supply the exact user's head without rendering hotel clothes
         * underneath the converted coat.
         */
        public static function headOnlyFigure(baseFigure:String):String
        {
var set:String  = null, separator = 0, type:String  = null;            if (baseFigure == null || baseFigure == "") return "";
            var kept:Array<ASAny> = [];
            final _iter_ = baseFigure.split("."); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
set = _tmp_;
separator= set.indexOf("-");
type= separator < 0 ? set : set.substr(0, separator);
                if (ASCompat.getDynamicProperty(HEAD_TYPES, type)) kept.push(set);
            }
            return kept.join(".");
        }

        /** Multi-team uses the four fixed r26 colours; one-team uses chest colour or EEEEEE. */
        public static function colour(avatars:IAvatarRenderManager, baseFigure:String,
                                      teamCount:Int, teamId:Int):UInt
        {
            if (teamCount > 1)
            {
                return teamId >= 0 && teamId < TEAM_COLOURS.length
                    ? ASCompat.toUInt(TEAM_COLOURS[teamId]) : FALLBACK_COLOUR;
            }
            if (avatars == null || baseFigure == null || baseFigure == "") return FALLBACK_COLOUR;
            var figure= avatars._Str_718(baseFigure);
            if (figure == null || !figure._Str_744(AvatarFigurePartType.CHEST)) return FALLBACK_COLOUR;
            var colours= figure._Str_815(AvatarFigurePartType.CHEST);
            if (colours == null || colours.length == 0) return FALLBACK_COLOUR;
            var structure= avatars._Str_813();
            if (structure == null) return FALLBACK_COLOUR;
            var setType= structure._Str_740(AvatarFigurePartType.CHEST);
            if (setType == null) return FALLBACK_COLOUR;
            var palette= structure.getPalette(setType._Str_734);
            if (palette == null) return FALLBACK_COLOUR;
            var partColour= palette.getColor(ASCompat.toInt(colours[0]));
            return partColour == null ? FALLBACK_COLOUR : partColour._Str_915;
        }

	public function new() {}
    }

