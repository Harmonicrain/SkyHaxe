package com.sulake.habbo.notifications.feed
;
    import com.sulake.habbo.notifications.FeedVisibilityEnum;

     class StateController 
    {
        var _isEnabled:Bool = false;
        var _isGameMode:Bool = false;
        var _currentState:Int = 0;
        var _lastRequestedState:Int = 0;

        public function new()
        {
            this._currentState = FeedVisibilityEnum.VIEW_STATE_HIDDEN;
            this._lastRequestedState = FeedVisibilityEnum.VIEW_STATE_MINIMIZED;
        }

        function isActive():Bool
        {
            return this._isEnabled && (!this._isGameMode);
        }

        public function setEnabled(k:Bool):Int
        {
            this._isEnabled = k;
            if (!this.isActive())
            {
                return this.requestState(FeedVisibilityEnum.VIEW_STATE_HIDDEN);
            }
            return this.setVisible();
        }

        public function setGameMode(k:Bool):Int
        {
            this._isGameMode = k;
            if (!this.isActive())
            {
                return this.requestState(FeedVisibilityEnum.VIEW_STATE_HIDDEN);
            }
            return this.setVisible();
        }

        public function currentState():Int
        {
            return this._currentState;
        }

        public function requestState(k:Int):Int
        {
            if (!this.isActive())
            {
                this._lastRequestedState = k;
                return this._currentState;
            }
            this._currentState = k;
            this._lastRequestedState = k;
            return this._currentState;
        }

        function setVisible():Int
        {
            var k= this._lastRequestedState;
            if (k == FeedVisibilityEnum.VIEW_STATE_HIDDEN)
            {
                k = FeedVisibilityEnum.VIEW_STATE_MINIMIZED;
            }
            this._currentState = k;
            this._lastRequestedState = k;
            return k;
        }
    }

