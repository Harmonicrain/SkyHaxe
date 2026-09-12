package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextFormatAlign;

     class GamehallBattleshipsView extends GamehallGameViewBase
    {
        static inline final OK_HIT_X= 77;
        static inline final OK_HIT_Y= 211;
        static inline final OK_HIT_WIDTH= 121;
        static inline final OK_HIT_HEIGHT= 16;
        static inline final GAME_RESULT_WIN= "WIN";
        static inline final GAME_RESULT_LOSE= "LOSE";

        var _gameResultLocked:Bool = false;
        var _ownGrid:String = "";
        var _opponentGrid:String = "";
        var _turnSeat:Int = -1;
        var _placeQueue:Array<ASAny> = [];
        var _placedShips:Array<ASAny> = [];
        var _placeHorizontal:Bool = true;
        var _placeWaiting:Bool = false;
        var _ghostSprite:Sprite;
        var _ghostCol:Int = -1;
        var _ghostRow:Int = -1;

        public function new(sendMove:ASFunction, invalidate:ASFunction)
        {
            super(sendMove, invalidate);
        }

        override public function reset(localSeat:Int, seatCount:Int)
        {
            super.reset(localSeat, seatCount);
            this._gameResultLocked = false;
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this.resetPlacement();
        }

        override public function applyUpdate(verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            if (verb == GamehallCommands.RESTART || verb == "STARTOVER")
            {
                this.resetBattleshipsBoardState();
                return;
            }
            if (verb == GamehallUpdates.SITUATION)
            {
                this._gameResultLocked = false;
                this._mode = "board";
                if (args != null)
                {
                    if (args.length > 1)
                    {
                        this._ownGrid = ASCompat.toString(args[1]);
                    }
                    if (args.length > 3)
                    {
                        this._opponentGrid = ASCompat.toString(args[3]);
                    }
                }
                this._status = this.turnStatus();
                return;
            }
            if (verb == GamehallUpdates.FLEET)
            {
                this._gameResultLocked = false;
                this.applyBattleshipsFleet(args);
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
            if (verb == GamehallUpdates.HIT || verb == GamehallUpdates.HIT_TWICE || verb == GamehallUpdates.MISS || verb == GamehallUpdates.SINK)
            {
                this._mode = "board";
                if (verb == GamehallUpdates.HIT)
                {
                    this._status = "Hit!";
                }
                else if (verb == GamehallUpdates.HIT_TWICE)
                {
                    this._status = "Direct hit!";
                }
                else if (verb == GamehallUpdates.SINK)
                {
                    this._status = "Ship sunk!";
                }
                else
                {
                    this._status = "Miss!";
                }
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
            if (event.type == WindowMouseEvent.MOVE)
            {
                this.handlePlacementHover(event, window);
                return;
            }
            if (event.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (window == null)
            {
                return;
            }
            if (window.name == "ok_link" && this._mode == "start")
            {
                this.sendMove(GamehallCommands.OPEN, []);
                return;
            }
            if (window.name != "gamehall_canvas")
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
                this.handlePlacementClick(mouseEvent.localX, mouseEvent.localY);
                return;
            }
            if (this._mode == "board" && this._gameResultLocked)
            {
                if (this.pointInRect(mouseEvent.localX, mouseEvent.localY, 150, 248, 110, 16))
                {
                    this.sendMove(GamehallCommands.RESTART, []);
                }
                return;
            }
            if (this._mode == "board" && this._turnSeat == this._localSeat && this.pointInRect(mouseEvent.localX, mouseEvent.localY, GamehallGameViewBase.BOARD_HIT_X, GamehallGameViewBase.BOARD_HIT_Y, GamehallGameViewBase.BOARD_HIT_WIDTH, GamehallGameViewBase.BOARD_HIT_HEIGHT))
            {
                this.sendMove(GamehallCommands.SHOOT, [Std.int((mouseEvent.localX - GamehallGameViewBase.BOARD_HIT_X) / GamehallGameViewBase.CELL_SIZE), Std.int((mouseEvent.localY - GamehallGameViewBase.BOARD_HIT_Y) / GamehallGameViewBase.CELL_SIZE)]);
            }
        }

        override function drawStart()
        {
            if (this._placeWaiting)
            {
                this.drawGameScreenFallback();
                return;
            }
            this.drawBattleshipsPlacement();
        }

        override function drawBoard()
        {
var ship:ASObject  = null;            var board= this.assetDisplay("hh_games_game_battleships_board_real");
            if (board != null)
            {
                board.x = GamehallGameViewBase.BOARD_OFFSET_X;
                this._panel.addChild(board);
            }
            else
            {
                this.drawBoardFallback();
            }
            if (this.isBattleshipsDefenceView())
            {
                final _iter_ = this._placedShips; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
ship = _tmp_;
                    this.drawPlacedShip(ASCompat.toInt(ship.length), ASCompat.toInt(ship.col), ASCompat.toInt(ship.row), ASCompat.toBool(ship.horizontal), 1.0);
                }
            }
            this.drawBattleshipsMarkers();
        }

        override function drawPanelText()
        {
            if (this._mode == "start")
            {
                if (this._placeWaiting)
                {
                    this._panel.addChild(this.createPanelText("WAITING FOR THE OPPONENT", 0, 124, GamehallGameViewBase.SCREEN_WIDTH, 16, 9, 0xEEEEEE, TextFormatAlign.CENTER, false, true));
                }
                else
                {
                    this._panel.addChild(this.createPanelText(this.placementLabel(), 10, 250, 150, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false, true));
                    this._panel.addChild(this.createPanelText("TURN", 150, 250, 110, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
                }
                return;
            }
            this._panel.addChild(this.createPanelText(this._status, 10, 250, 135, 14, 9, 0x00CC00, TextFormatAlign.LEFT, false));
            if (this._gameResultLocked)
            {
                this._panel.addChild(this.createPanelText("New game", 150, 250, 100, 14, 9, 0x00CC00, TextFormatAlign.RIGHT, true, true));
            }
        }

        override function turnStatus():String
        {
            if (this._turnSeat < 0)
            {
                return this._status;
            }
            return this._turnSeat == this._localSeat ? "Your turn!" : "The Enemy's Turn";
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

        function resetPlacement()
        {
            this._placeQueue = [];
            this._placedShips = [];
            this._placeHorizontal = true;
            this._placeWaiting = false;
            this._ghostSprite = null;
            this._ghostCol = -1;
            this._ghostRow = -1;
            this.queueShips(5, 1);
            this.queueShips(4, 2);
            this.queueShips(3, 3);
            this.queueShips(2, 4);
        }

        function resetBattleshipsBoardState()
        {
            this._mode = "start";
            this._status = "";
            this._gameResultLocked = false;
            this._ownGrid = "";
            this._opponentGrid = "";
            this._turnSeat = -1;
            this.resetPlacement();
        }

        function queueShips(length:Int, count:Int)
        {
var i = 0;            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._placeQueue.push(length);
            }
        }

        function drawBattleshipsPlacement()
        {
var ship:ASObject  = null;            var board= this.assetDisplay("hh_games_game_battleships_board_real");
            if (board != null)
            {
                board.x = GamehallGameViewBase.BOARD_OFFSET_X;
                this._panel.addChild(board);
            }
            else
            {
                this.drawBoardFallback();
            }
            final _iter_ = this._placedShips; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
ship = _tmp_;
                this.drawPlacedShip(ASCompat.toInt(ship.length), ASCompat.toInt(ship.col), ASCompat.toInt(ship.row), ASCompat.toBool(ship.horizontal), 1.0);
            }
            this._ghostSprite = new Sprite();
            this._ghostSprite.mouseEnabled = false;
            this._ghostSprite.mouseChildren = false;
            this._panel.addChild(this._ghostSprite);
            this.drawGhost();
        }

        function drawGhost()
        {
            if (this._ghostSprite == null)
            {
                return;
            }
            while (this._ghostSprite.numChildren > 0)
            {
                this._ghostSprite.removeChildAt(0);
            }
            this._ghostSprite.graphics.clear();
            if (this._placeWaiting || this._placeQueue.length == 0 || this._ghostCol < 0 || this._ghostRow < 0)
            {
                return;
            }
            var length= ASCompat.toInt(this._placeQueue[0]);
            var head:ASObject = this.placementHead(this._ghostCol, this._ghostRow, length);
            this.drawShipInto(this._ghostSprite, length, ASCompat.toInt(head.col), ASCompat.toInt(head.row), this._placeHorizontal, 1.0);
        }

        function placementHead(col:Int, row:Int, length:Int):ASObject
        {
            var headCol= col;
            var headRow= row;
            if (this._placeHorizontal)
            {
                headCol = col - Std.int(length / 2);
                if (headCol < 0) { headCol = 0; }
                if (headCol + length > GamehallGameViewBase.BOARD_COLUMNS) { headCol = GamehallGameViewBase.BOARD_COLUMNS - length; }
            }
            else
            {
                headRow = row - Std.int(length / 2);
                if (headRow < 0) { headRow = 0; }
                if (headRow + length > GamehallGameViewBase.BOARD_ROWS) { headRow = GamehallGameViewBase.BOARD_ROWS - length; }
            }
            return {col:headCol, row:headRow};
        }

        function drawPlacedShip(length:Int, col:Int, row:Int, horizontal:Bool, alpha:Float)
        {
            this.drawShipInto(this._panel, length, col, row, horizontal, alpha);
        }

        function drawShipInto(target:Sprite, length:Int, col:Int, row:Int, horizontal:Bool, alpha:Float)
        {
            var px= GamehallGameViewBase.BOARD_HIT_X + col * GamehallGameViewBase.CELL_SIZE;
            var py= GamehallGameViewBase.BOARD_HIT_Y + row * GamehallGameViewBase.CELL_SIZE;
            var footWidth= horizontal ? length * GamehallGameViewBase.CELL_SIZE : GamehallGameViewBase.CELL_SIZE;
            var footHeight= horizontal ? GamehallGameViewBase.CELL_SIZE : length * GamehallGameViewBase.CELL_SIZE;
            var name= "hh_games_game_bs_ship_" + Std.string(length) + (horizontal ? "_h" : "_v");
            var display= this.assetDisplay(name);
            if (display != null)
            {
                display.x = px + Std.int((footWidth - display.width) / 2);
                display.y = py + Std.int((footHeight - display.height) / 2);
                display.alpha = alpha;
                target.addChild(display);
                return;
            }
            var g:ASAny = target.graphics;
            g.lineStyle(2, 0x66CC00, alpha);
            g.beginFill(0x66CC00, 0.15 * alpha + 0.05);
            g.drawRoundRect(px + 2, py + 2, footWidth - 4, footHeight - 4, 9, 9);
            g.endFill();
        }

        function placementLabel():String
        {
var entry:ASAny  = null;            if (this._placeQueue.length == 0)
            {
                return "";
            }
            var length= ASCompat.toInt(this._placeQueue[0]);
            if (length == 5)
            {
                return "An aircraft carrier";
            }
            var count= 0;
            final _iter_ = this._placeQueue; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
entry = _tmp_;
                if (ASCompat.toInt(entry) == length)
                {
                    count++;
                }
            }
            return Std.string(count) + " " + this.shipName(length) + "(s)";
        }

        function shipName(length:Int):String
        {
            switch (length)
            {
                case 5: return "Aircraft Carrier";
                case 4: return "Battle Ship";
                case 3: return "Cruiser";
                case 2: return "Destroyer";
            }
            return "Ship";
        }

        function handlePlacementHover(event:WindowEvent, window:IWindow)
        {
            if (window == null || window.name != "gamehall_canvas" || this._mode != "start" || this._placeWaiting)
            {
                return;
            }
            var moveEvent= Std.downcast(event , WindowMouseEvent);
            if (moveEvent == null)
            {
                return;
            }
            var col= Std.int((moveEvent.localX - GamehallGameViewBase.BOARD_HIT_X) / GamehallGameViewBase.CELL_SIZE);
            var row= Std.int((moveEvent.localY - GamehallGameViewBase.BOARD_HIT_Y) / GamehallGameViewBase.CELL_SIZE);
            if (col < 0 || col >= GamehallGameViewBase.BOARD_COLUMNS || row < 0 || row >= GamehallGameViewBase.BOARD_ROWS)
            {
                col = -1;
                row = -1;
            }
            if (col != this._ghostCol || row != this._ghostRow)
            {
                this._ghostCol = col;
                this._ghostRow = row;
                this.drawGhost();
            }
        }

        function handlePlacementClick(localX:Float, localY:Float)
        {
            if (this._placeWaiting)
            {
                return;
            }
            if (this.pointInRect(localX, localY, 150, 248, 110, 16))
            {
                this._placeHorizontal = !this._placeHorizontal;
                this.invalidate();
                return;
            }
            var col= Std.int((localX - GamehallGameViewBase.BOARD_HIT_X) / GamehallGameViewBase.CELL_SIZE);
            var row= Std.int((localY - GamehallGameViewBase.BOARD_HIT_Y) / GamehallGameViewBase.CELL_SIZE);
            if (col < 0 || col >= GamehallGameViewBase.BOARD_COLUMNS || row < 0 || row >= GamehallGameViewBase.BOARD_ROWS)
            {
                return;
            }
            this.tryPlaceCurrentShip(col, row);
        }

        function tryPlaceCurrentShip(col:Int, row:Int)
        {
            if (this._placeQueue.length == 0)
            {
                return;
            }
            var length= ASCompat.toInt(this._placeQueue[0]);
            var head:ASObject = this.placementHead(col, row, length);
            var headCol= ASCompat.toInt(head.col);
            var headRow= ASCompat.toInt(head.row);
            var endCol= this._placeHorizontal ? headCol + length - 1 : headCol;
            var endRow= this._placeHorizontal ? headRow : headRow + length - 1;
            if (this.placementOverlaps(headCol, headRow, endCol, endRow))
            {
                return;
            }
            this.sendMove(GamehallCommands.PLACE_SHIP, [length, headCol, headRow, endCol, endRow]);
            this._placedShips.push({length:length, col:headCol, row:headRow, horizontal:this._placeHorizontal});
            this._placeQueue.shift();
            if (this._placeQueue.length == 0)
            {
                this._placeWaiting = true;
                this._status = "Waiting for opponent";
            }
            this.invalidate();
        }

        function placementOverlaps(startCol:Int, startRow:Int, endCol:Int, endRow:Int):Bool
        {
var ship:ASObject  = null, oc = 0, orow = 0, olen = 0, oec = 0, oer = 0;            final _iter_ = this._placedShips; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
ship = _tmp_;
oc= ASCompat.toInt(ship.col);
orow= ASCompat.toInt(ship.row);
olen= ASCompat.toInt(ship.length);
oec= ASCompat.toBool(ship.horizontal) ? oc + olen - 1 : oc;
oer= ASCompat.toBool(ship.horizontal) ? orow : orow + olen - 1;
                if (startCol <= oec && endCol >= oc && startRow <= oer && endRow >= orow)
                {
                    return true;
                }
            }
            return false;
        }

        function applyBattleshipsFleet(args:Array<ASAny>)
        {
var entry:String  = null, fields:Array<ASAny>  = null, length = 0, col = 0, row = 0, horizontal = false;            this._placedShips = [];
            if (args == null || args.length == 0)
            {
                return;
            }
            var encoded= ASCompat.toString(args[0]);
            if (encoded == "")
            {
                return;
            }
            var entries:Array<ASAny> = (cast encoded.split(";"));
            if (checkNullIteratee(entries)) for (_tmp_ in entries)
            {
entry = _tmp_;
fields= (cast entry.split(","));
                if (fields.length < 4)
                {
                    continue;
                }
length= ASCompat.toInt(fields[0]);
col= ASCompat.toInt(fields[1]);
row= ASCompat.toInt(fields[2]);
horizontal= ASCompat.toString(fields[3]).toUpperCase() != "V";
                if (length < 2 || length > 5 || col < 0 || row < 0)
                {
                    continue;
                }
                if (horizontal && col + length > GamehallGameViewBase.BOARD_COLUMNS)
                {
                    continue;
                }
                if (!horizontal && row + length > GamehallGameViewBase.BOARD_ROWS)
                {
                    continue;
                }
                this._placedShips.push({length:length, col:col, row:row, horizontal:horizontal});
            }
            if (this._placedShips.length >= 10)
            {
                this._placeQueue = [];
                this._placeWaiting = this._mode != "board";
            }
        }

        function drawBattleshipsMarkers()
        {
var row = 0, column = 0, index = 0, marker:String  = null;            var grid= this.battleshipsVisibleGrid();
            if (grid == null || grid.length == 0)
            {
                return;
            }
            for (_tmp_ in 0...GamehallGameViewBase.BOARD_ROWS)
            {
row= _tmp_;
                for (_tmp_ in 0...GamehallGameViewBase.BOARD_COLUMNS)
                {
column= _tmp_;
index= row * GamehallGameViewBase.BOARD_COLUMNS + column;
                    if (index >= grid.length)
                    {
                        return;
                    }
marker= grid.charAt(index);
                    if (marker == "-" || marker == "")
                    {
                        continue;
                    }
                    this.drawBattleshipsMarker(marker, column, row);
                }
            }
        }

        function battleshipsVisibleGrid():String
        {
            var preferred= this.isBattleshipsDefenceView() ? this._ownGrid : this._opponentGrid;
            if (preferred != null && preferred.length > 0)
            {
                return preferred;
            }
            return this.isBattleshipsDefenceView() ? this._opponentGrid : this._ownGrid;
        }

        function isBattleshipsDefenceView():Bool
        {
            return this._turnSeat >= 0 && this._turnSeat != this._localSeat;
        }

        function drawBattleshipsMarker(marker:String, column:Int, row:Int)
        {
            var assetName:String = null;
            if (marker == "X")
            {
                assetName = "hh_games_game_bs_hit";
            }
            else if (marker == "O")
            {
                assetName = "hh_games_game_bs_miss";
            }
            else if (marker == "S")
            {
                assetName = "hh_games_game_bs_sink";
            }
            var display:DisplayObject = assetName == null ? null : this.assetDisplay(assetName);
            if (display != null)
            {
                display.x = GamehallGameViewBase.BOARD_HIT_X + column * GamehallGameViewBase.CELL_SIZE + Std.int((GamehallGameViewBase.CELL_SIZE - display.width) / 2);
                display.y = GamehallGameViewBase.BOARD_HIT_Y + row * GamehallGameViewBase.CELL_SIZE + Std.int((GamehallGameViewBase.CELL_SIZE - display.height) / 2);
                this._panel.addChild(display);
                return;
            }
            this._panel.addChild(this.createPanelText(marker, GamehallGameViewBase.BOARD_HIT_X + column * GamehallGameViewBase.CELL_SIZE, GamehallGameViewBase.BOARD_HIT_Y + row * GamehallGameViewBase.CELL_SIZE + 4, GamehallGameViewBase.CELL_SIZE, 12, 9, 0x66CC00, TextFormatAlign.CENTER, false));
        }
    }

