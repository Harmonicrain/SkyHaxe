package com.sulake.core.utils.profiler
;
    import com.sulake.core.runtime.IDisposable;

     class ProfilerAgentTask implements IDisposable 
    {
        var _name:String;
        var _rounds:UInt = 0;
        var _total:Int = 0;
        var _latest:Int = 0;
        var _average:Float = Math.NaN;
        var _caption:String;
        var _running:Bool = false;
        var _disposed:Bool = false;
        var _children:Array<ASAny>;
        var _startTime:UInt = 0;
        var _paused:Bool = false;

        public function new(name:String, caption:String="")
        {
            this._name = name;
            this._rounds = 0;
            this._average = 0;
            this._running = false;
            this._children = new Array<ASAny>();
            this._caption = caption;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._disposed = true;
            }
        }

        public function start()
        {
            if (!this._running)
            {
                this._startTime = flash.Lib.getTimer();
                this._running = true;
            }
        }

        public function stop()
        {
            if (this._running)
            {
                this._latest = ASCompat.toInt(flash.Lib.getTimer() - this._startTime);
                this._rounds++;
                this._total = (this._total + this._latest);
                this._average = (this._total / this._rounds);
                this._running = false;
            }
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var rounds(get,never):UInt;
public function  get_rounds():UInt
        {
            return this._rounds;
        }

        public var total(get,never):Int;
public function  get_total():Int
        {
            return this._total;
        }

        public var latest(get,never):Int;
public function  get_latest():Int
        {
            return this._latest;
        }

        public var average(get,never):Float;
public function  get_average():Float
        {
            return this._average;
        }

        
        public var caption(get,set):String;
public function  get_caption():String
        {
            return this._caption;
        }
public function  set_caption(caption:String):String        {
            return this._caption = caption;
        }

        public var running(get,never):Bool;
public function  get_running():Bool
        {
            return this._running;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var paused(get,set):Bool;
public function  get_paused():Bool
        {
            return this._paused;
        }
public function  set_paused(paused:Bool):Bool        {
            return this._paused = paused;
        }

        public var numSubTasks(get,never):UInt;
public function  get_numSubTasks():UInt
        {
            return this._children.length;
        }

        public function addSubTask(subTask:ProfilerAgentTask)
        {
            if (this.getSubTaskByName(subTask.name) != null)
            {
                throw new ASError((('Component profiler task with name "' + subTask.name) + '" already exists!'));
            }
            this._children.push(subTask);
        }

        public function removeSubTask(k:ProfilerAgentTask):ProfilerAgentTask
        {
            var index= this._children.indexOf(k);
            if (index > -1)
            {
                this._children.splice(index, 1);
            }
            return k;
        }

        public function getSubTaskAt(k:UInt):ProfilerAgentTask
        {
            return ASCompat.dynamicAs(this._children[ASCompat.toInt(k)] , ProfilerAgentTask);
        }

        public function getSubTaskByName(name:String):ProfilerAgentTask
        {
var subTask:ProfilerAgentTask  = null;            var index:UInt = 0;
            while (index < (this._children.length : UInt))
            {
subTask= ASCompat.dynamicAs(this._children[ASCompat.toInt(index++)] , ProfilerAgentTask);
                if (subTask.name == name)
                {
                    return subTask;
                }
            }
            return null;
        }
    }

