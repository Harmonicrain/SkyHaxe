package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.display.Sprite;
    import flash.text.TextFormatAlign;

     class GamehallTicTacToeView extends GamehallGameViewBase
    {
        static inline final TTT_CHOOSE_GLYPH_Y= 86;
        static inline final TTT_CHOOSE_GLYPH_BLOCK= 4;
        static inline final TTT_BOARD_X= 14;
        static inline final TTT_BOARD_Y= 15;
        static inline final TTT_BOARD_COLUMNS= 24;
        static inline final TTT_BOARD_ROWS= 23;
        static inline final TTT_CELL_SIZE= 10;
        static inline final TTT_MARK_OFFSET_X= 1;
        static inline final TTT_MARK_OFFSET_Y= 1;
        static inline final TTT_X_CHOOSE_X= 83;
        static inline final TTT_O_CHOOSE_X= 163;
        static inline final TTT_CHOOSE_SIZE= 40;
        static inline final GAME_RESULT_WIN= "WIN";
        static inline final GAME_RESULT_LOSE= "LOSE";

        var _gameResultLocked:Bool = false;
        var _turnSeat:Int = -1;
        var _tttSide:String = "";
        var _tttBoardData:String = "";

        public function new(sendMove:ASFunction, invalidate:ASFunction)
        {
            super(sendMove, invalidate);
        }

        override public function reset(localSeat:Int, seatCount:Int)
        {
            super.reset(localSeat, seatCount);
            this._gameResultLocked = false;
            this._turnSeat = -1;
            this._tttSide = "";
            this._tttBoardData = "";
        }

        override public function applyUpdate(verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            if (verb == GamehallUpdates.SELECT_TYPE)
            {
                this._gameResultLocked = false;
                if (args != null && args.length > 0)
                {
                    this._tttSide = ASCompat.toString(args[0]).toUpperCase();
                }
                this._status = this._tttSide == "" ? "Side selected" : "Playing " + this._tttSide;
                return;
            }
            if (verb == GamehallUpdates.TYPE_RESERVED)
            {
                if (!this._gameResultLocked)
                {
                    this._status = "Reserved";
                }
                return;
            }
            if (verb == GamehallUpdates.BOARD_DATA)
            {
                this._gameResultLocked = false;
                this._mode = "board";
                if (args != null)
                {
                    if (args.length > 0)
                    {
                        this._status = ASCompat.toString(args[0]);
                    }
                    if (args.length > 2)
                    {
                        this._tttBoardData = ASCompat.toString(args[2]);
                    }
                }
                return;
            }
            if (verb == GamehallUpdates.TURN)
            {
                this._gameResultLocked = false;
                this._mode = "board";
                if (args != null && args.length > 0)
                {
                    this._turnSeat = ASCompat.toInt(args[0]);
                }
                this._status = this.turnStatus();
                return;
            }
            if (verb == GamehallUpdates.WAIT)
            {
                this._gameResultLocked = false;
                this._status = args != null && args.length > 0 ? args.join(" ") : "Waiting for opponent";
                return;
            }
            if (verb == GamehallUpdates.OPPONENTS)
            {
                this._gameResultLocked = false;
                this._status = "Opponent ready";
                return;
            }
            if (verb == GamehallUpdates.GAME_END)
            {
                this._mode = "board";
                this._gameResultLocked = true;
                this._status = this.gameEndStatus(args);
                return;
            }
            if (verb == GamehallUpdates.GAME_OVER)
            {
                this._mode = "board";
                if (!this._gameResultLocked)
                {
                    this._status = "Game over";
                }
                return;
            }
            super.applyUpdate(verb, args, reason);
        }

        override public function handleWindowEvent(event:WindowEvent, window:IWindow)
        {
            if (event.type != WindowMouseEvent.CLICK || window == null || window.name != "gamehall_canvas")
            {
                return;
            }
            var mouseEvent= Std.downcast(event , WindowMouseEvent);
            if (mouseEvent == null)
            {
                return;
            }
            if (this._mode == "start")
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_X_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                {
                    this.sendMove(GamehallCommands.CHOOSE_TYPE, ["X"]);
                }
                else if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_O_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, TTT_CHOOSE_SIZE, TTT_CHOOSE_SIZE))
                {
                    this.sendMove(GamehallCommands.CHOOSE_TYPE, ["O"]);
                }
                return;
            }
            if (this._mode == "board")
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, 148, 247, 100, 14))
                {
                    this.sendMove(GamehallCommands.RESTART, []);
                    return;
                }
                if (!this._gameResultLocked && this._tttSide != "" && this.pointInRect(mouseEvent.localX, mouseEvent.localY, TTT_BOARD_X, TTT_BOARD_Y, TTT_BOARD_COLUMNS * TTT_CELL_SIZE, TTT_BOARD_ROWS * TTT_CELL_SIZE))
                {
                    this.sendMove(GamehallCommands.SET_SECTOR, [this._tttSide, Std.int((mouseEvent.localX - TTT_BOARD_X) / TTT_CELL_SIZE), Std.int((mouseEvent.localY - TTT_BOARD_Y) / TTT_CELL_SIZE)]);
                }
            }
        }

        override function drawStart()
        {
            this.drawClassicGameScreen();
            var board= this.assetDisplay("hh_games_game_TicTacToe_board_real");
            if (board != null)
            {
                board.x = TTT_BOARD_X;
                board.y = TTT_BOARD_Y;
                this._panel.addChild(board);
            }
            else
            {
                this.drawTicTacToeFallbackGrid();
            }
            this.addTicTacToeChooseGlyph("X", TTT_X_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, 0x003366);
            this.addTicTacToeChooseGlyph("O", TTT_O_CHOOSE_X, TTT_CHOOSE_GLYPH_Y, 0x770000);
            this._panel.addChild(this.createPanelText("Choose your side", 17, 247, 121, 22, 9, 0xEEEEEE, TextFormatAlign.LEFT, false, false));
        }

        override function drawBoard()
        {
            this.drawClassicGameScreen();
            var board= this.assetDisplay("hh_games_game_TicTacToe_board_real");
            if (board != null)
            {
                board.x = TTT_BOARD_X;
                board.y = TTT_BOARD_Y;
                this._panel.addChild(board);
            }
            else
            {
                this.drawTicTacToeFallbackGrid();
            }
            this.drawTicTacToeMarks();
        }

        override function drawPanelText()
        {
            if (this._mode != "board")
            {
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 17, 247, 135, 14, 9, 0xEEEEEE, TextFormatAlign.LEFT, false, false));
            this._panel.addChild(this.createPanelText("New game", 148, 247, 100, 14, 9, 0xEEEEEE, TextFormatAlign.RIGHT, true, false));
        }

        override function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            return this._turnSeat == this._localSeat ? "Your turn" : "Opponent's turn";
        }

        function gameEndStatus(args:Array<ASAny>):String
        {
            if (args == null || args.length == 0)
            {
                return "Game over";
            }
            var result= ASCompat.toString(args[0]).toUpperCase();
            if (result == GAME_RESULT_WIN)
            {
                return "You Won!";
            }
            if (result == GAME_RESULT_LOSE)
            {
                return "Game over";
            }
            return ASCompat.toString(args[0]) + " wins";
        }

        function addTicTacToeChooseGlyph(caption:String, x:Int, y:Int, color:UInt)
        {
var             row = 0, line:String  = null,                 column = 0;            var sprite= new Sprite();
            sprite.x = x;
            sprite.y = y;
            var mask= caption == "O" ?
                ["..######..",
                 "..######..",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "##......##",
                 "..######..",
                 "..######.."] :
                ["##......##",
                 "##......##",
                 "..##..##..",
                 "..##..##..",
                 "....##....",
                 "....##....",
                 "..##..##..",
                 "..##..##..",
                 "##......##",
                 "##......##"];
            sprite.graphics.beginFill(color);
            row= 0;while (row < mask.length)
            {
line= mask[row];
                column= 0;while (column < line.length)
                {
                    if (line.charAt(column) == "#")
                    {
                        sprite.graphics.drawRect(column * TTT_CHOOSE_GLYPH_BLOCK, row * TTT_CHOOSE_GLYPH_BLOCK, TTT_CHOOSE_GLYPH_BLOCK, TTT_CHOOSE_GLYPH_BLOCK);
                    }
column++;
                }
row++;
            }
            sprite.graphics.endFill();
            this._panel.addChild(sprite);
        }

        function drawTicTacToeMarks()
        {
var row = 0, column = 0, index = 0, marker:String  = null;            if (this._tttBoardData == null || this._tttBoardData.length == 0)
            {
                return;
            }
            for (_tmp_ in 0...TTT_BOARD_ROWS)
            {
row= _tmp_;
                for (_tmp_ in 0...TTT_BOARD_COLUMNS)
                {
column= _tmp_;
index= row * (TTT_BOARD_COLUMNS + 1) + column;
                    if (index >= this._tttBoardData.length)
                    {
                        return;
                    }
marker= this._tttBoardData.charAt(index);
                    if (marker == " " || marker == "")
                    {
                        continue;
                    }
                    this.addTicTacToeBoardGlyph(marker, TTT_BOARD_X + column * TTT_CELL_SIZE + TTT_MARK_OFFSET_X, TTT_BOARD_Y + row * TTT_CELL_SIZE + TTT_MARK_OFFSET_Y);
                }
            }
        }

        function addTicTacToeBoardGlyph(marker:String, x:Int, y:Int)
        {
var             row = 0, line:String  = null,                 column = 0;            var normalized= marker == "q" ? "O" : marker == "+" ? "X" : marker;
            if (normalized != "X" && normalized != "O")
            {
                return;
            }
            var color:UInt = normalized == "O" ? 0x770000 : 0x003366;
            var mask= normalized == "O" ?
                ["..#####..",
                 ".##...##.",
                 "##.....##",
                 "#.......#",
                 "#.......#",
                 "#.......#",
                 "##.....##",
                 ".##...##.",
                 "..#####.."] :
                ["##.....##",
                 ".##...##.",
                 "..##.##..",
                 "...###...",
                 "...###...",
                 "..##.##..",
                 ".##...##.",
                 "##.....##",
                 "#.......#"];
            var sprite= new Sprite();
            sprite.x = x;
            sprite.y = y;
            sprite.graphics.beginFill(color);
            row= 0;while (row < mask.length)
            {
line= mask[row];
                column= 0;while (column < line.length)
                {
                    if (line.charAt(column) == "#")
                    {
                        sprite.graphics.drawRect(column, row, 1, 1);
                    }
column++;
                }
row++;
            }
            sprite.graphics.endFill();
            this._panel.addChild(sprite);
        }

        function drawTicTacToeFallbackGrid()
        {
var column = 0, row = 0;            var g:ASAny = this._panel.graphics;
            g.lineStyle(1, 0x66CC00, 1);
            g.drawRect(TTT_BOARD_X, TTT_BOARD_Y, TTT_BOARD_COLUMNS * TTT_CELL_SIZE + 1, TTT_BOARD_ROWS * TTT_CELL_SIZE + 1);
            for (_tmp_ in 1...TTT_BOARD_COLUMNS)
            {
column= _tmp_;
                g.moveTo(TTT_BOARD_X + column * TTT_CELL_SIZE, TTT_BOARD_Y);
                g.lineTo(TTT_BOARD_X + column * TTT_CELL_SIZE, TTT_BOARD_Y + TTT_BOARD_ROWS * TTT_CELL_SIZE + 1);
            }
            for (_tmp_ in 1...TTT_BOARD_ROWS)
            {
row= _tmp_;
                g.moveTo(TTT_BOARD_X, TTT_BOARD_Y + row * TTT_CELL_SIZE);
                g.lineTo(TTT_BOARD_X + TTT_BOARD_COLUMNS * TTT_CELL_SIZE + 1, TTT_BOARD_Y + row * TTT_CELL_SIZE);
            }
        }
    }

