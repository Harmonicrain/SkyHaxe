package com.sulake.habbo.ui.widget.furniture.gamehall
;
     class GamehallGameTypes
    {
        public static inline final BATTLESHIPS= "battleships";
        public static inline final TICTACTOE= "tictactoe";
        public static inline final CHESS= "chess";
        public static inline final POKER= "poker";
        public static inline final BATTLEBALL= "battleball";
        public static inline final SNOWSTORM= "snowstorm";

        public static function normalize(gameType:String):String
        {
            var normalized= (gameType == null) ? "" : gameType.toLowerCase();
            // Tested before battleships: "battleball" also begins with "battle", so the looser
            // battleship match below would otherwise swallow it.
            if (normalized.indexOf("battleball") >= 0 || normalized.indexOf("battle_ball") >= 0)
            {
                return BATTLEBALL;
            }
            if (normalized.indexOf("snowstorm") >= 0 || normalized.indexOf("snow_storm") >= 0)
            {
                return SNOWSTORM;
            }
            if (normalized.indexOf("battleship") >= 0 || normalized.indexOf("battle_ship") >= 0)
            {
                return BATTLESHIPS;
            }
            if (normalized.indexOf("tictactoe") >= 0 || normalized.indexOf("tic") >= 0)
            {
                return TICTACTOE;
            }
            if (normalized.indexOf("chess") >= 0)
            {
                return CHESS;
            }
            if (normalized.indexOf("poker") >= 0)
            {
                return POKER;
            }
            return BATTLESHIPS;
        }

	public function new() {}
    }

