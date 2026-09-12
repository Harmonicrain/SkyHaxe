package com.sulake.habbo.ui.widget.furniture.gamehall
;
     class GamehallViewFactory
    {
        public static function create(gameType:String, sendMove:ASFunction, invalidate:ASFunction):GamehallGameView
        {
            switch (GamehallGameTypes.normalize(gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    return new GamehallTicTacToeView(sendMove, invalidate);
                case GamehallGameTypes.CHESS
                   | GamehallGameTypes.POKER:
                    return new GamehallPlaceholderView(gameType, sendMove, invalidate);
                default:
                    return new GamehallBattleshipsView(sendMove, invalidate);
            }
        }

	public function new() {}
    }

