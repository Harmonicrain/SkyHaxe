package window_conversion
{
    public class TrySuper extends SuperBase
    {
        public function TrySuper(value:int)
        {
            try { super(value); }
            catch (error:Error) { throw error; }
        }
        public function value():int { return baseValue; }
    }
}
