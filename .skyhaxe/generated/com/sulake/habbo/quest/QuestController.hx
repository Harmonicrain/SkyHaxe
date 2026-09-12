package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.quest.seasonalcalendar.MainWindow;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;

     class QuestController implements IDisposable implements  IUpdateReceiver 
    {
        var _questEngine:HabboQuestEngine;
        var _questsList:QuestsList;
        var _questDetails:QuestDetails;
        var _questCompleted:QuestCompleted;
        var _questTracker:QuestTracker;
        var _nextQuestTimer:NextQuestTimer;
        var _seasonalCalendarWindow:MainWindow;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
            this._questTracker = new QuestTracker(this._questEngine);
            this._questsList = new QuestsList(this._questEngine);
            this._questDetails = new QuestDetails(this._questEngine);
            this._questCompleted = new QuestCompleted(this._questEngine);
            this._nextQuestTimer = new NextQuestTimer(this._questEngine);
            this._seasonalCalendarWindow = new MainWindow(this._questEngine);
        }

        public function onToolbarClick()
        {
            if (this._questEngine._Str_19304())
            {
                this._seasonalCalendarWindow.onToolbarClick();
                this._questsList.close();
            }
            else
            {
                this._questsList.onToolbarClick();
            }
        }

        public function _Str_4750(k:QuestMessageData)
        {
            this._questTracker._Str_4750(k);
            this._questDetails._Str_4750(k);
            this._questCompleted._Str_4750(k);
            this._nextQuestTimer._Str_4750(k);
        }

        public function _Str_5657(k:QuestMessageData, _arg_2:Bool)
        {
            this._questTracker._Str_5657(k, _arg_2);
            this._questDetails._Str_5657(k);
            this._questCompleted._Str_5657(k, _arg_2);
        }

        public function _Str_5242()
        {
            this._questTracker._Str_5242();
            this._questDetails._Str_5242();
            this._questCompleted._Str_5242();
            this._nextQuestTimer._Str_5242();
        }

        public function onRoomEnter()
        {
            this._questTracker.onRoomEnter();
        }

        public function onRoomExit()
        {
            this._questsList.onRoomExit();
            this._seasonalCalendarWindow.onRoomExit();
            this._questTracker.onRoomExit();
            this._questDetails.onRoomExit();
            this._nextQuestTimer.onRoomExit();
        }

        public function update(k:UInt)
        {
            this._questCompleted.update(k);
            this._questTracker.update(k);
            this._nextQuestTimer.update(k);
            this._questsList.update(k);
            this._questDetails.update(k);
            this._seasonalCalendarWindow.update(k);
        }

        public function dispose()
        {
            this._questEngine = null;
            if (this._questsList != null)
            {
                this._questsList.dispose();
                this._questsList = null;
            }
            if (this._questTracker != null)
            {
                this._questTracker.dispose();
                this._questTracker = null;
            }
            if (this._questDetails != null)
            {
                this._questDetails.dispose();
                this._questDetails = null;
            }
            if (this._questCompleted != null)
            {
                this._questCompleted.dispose();
                this._questCompleted = null;
            }
            if (this._nextQuestTimer != null)
            {
                this._nextQuestTimer.dispose();
                this._nextQuestTimer = null;
            }
            if (this._seasonalCalendarWindow != null)
            {
                this._seasonalCalendarWindow.dispose();
                this._seasonalCalendarWindow = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public var _Str_12832(get,never):QuestsList;
public function  get__Str_12832():QuestsList
        {
            return this._questsList;
        }

        public var _Str_11417(get,never):QuestDetails;
public function  get__Str_11417():QuestDetails
        {
            return this._questDetails;
        }

        public var _Str_20198(get,never):QuestTracker;
public function  get__Str_20198():QuestTracker
        {
            return this._questTracker;
        }

        public var _Str_13628(get,never):MainWindow;
public function  get__Str_13628():MainWindow
        {
            return this._seasonalCalendarWindow;
        }

        public function onActivityPoints(k:Int, _arg_2:Int)
        {
            if (this._seasonalCalendarWindow != null)
            {
                this._seasonalCalendarWindow.onActivityPoints(k, _arg_2);
            }
        }
    }

