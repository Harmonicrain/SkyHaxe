package;

#if html5
import com.sulake.habbo.communication.connection.Html5HabboConnection;
import js.Browser;

/** Two-cycle regression probe over the same transport used by the runnable client. */
class G1bWebSocketProbe {
    static inline var REQUIRED_CYCLES:Int = 2;

    final endpoint:String;
    final ssoTicket:String;
    final expectedUsername:String;
    final report:(String, Bool) -> Void;
    var connection:Null<Html5HabboConnection>;
    var cycle:Int = 0;
    var authenticated:Bool = false;
    var finished:Bool = false;

    public function new(endpoint:String, ssoTicket:String, expectedUsername:String,
            report:(String, Bool) -> Void) {
        this.endpoint = endpoint;
        this.ssoTicket = ssoTicket;
        this.expectedUsername = expectedUsername;
        this.report = report;
    }

    public function start():Void {
        if (ssoTicket.length == 0) {
            fail("Missing SSO ticket; add #sso=<ticket>&user=<username> to the page URL");
            return;
        }
        connect();
    }

    function connect():Void {
        cycle++;
        authenticated = false;
        report('Cycle $cycle/$REQUIRED_CYCLES: starting', false);
        connection = new Html5HabboConnection(endpoint, {
            onStatus: function(message) report('Cycle $cycle/$REQUIRED_CYCLES: $message', false),
            onPacket: function(_, _) {},
            onAuthenticated: onAuthenticated,
            onClosed: onClosed,
            onError: fail
        });
        connection.connect(ssoTicket);
    }

    function onAuthenticated(username:String):Void {
        if (username.toLowerCase() != expectedUsername.toLowerCase()) {
            fail('Expected user $expectedUsername, authenticated as $username');
            return;
        }
        authenticated = true;
        report('Cycle $cycle/$REQUIRED_CYCLES: authenticated as $username; closing cleanly', false);
        connection.close("G1b cycle complete");
    }

    function onClosed(code:Int, clean:Bool):Void {
        if (finished) return;
        if (!authenticated) {
            fail('Connection closed before authentication completed (code $code)');
            return;
        }
        if (!clean || code != 1000) {
            fail('Connection did not close cleanly (code $code, clean $clean)');
            return;
        }
        if (cycle < REQUIRED_CYCLES) {
            report('Cycle $cycle/$REQUIRED_CYCLES: clean close confirmed; reconnecting', false);
            Browser.window.setTimeout(connect, 1000);
            return;
        }
        finished = true;
        Browser.document.documentElement.setAttribute("data-skyhaxe-g1b", "pass");
        Browser.console.info("SKYHAXE_G1B_PASS");
        report('PASS: authenticated as $expectedUsername twice with one clean reconnect', true);
    }

    function fail(message:String):Void {
        if (finished) return;
        finished = true;
        Browser.document.documentElement.setAttribute("data-skyhaxe-g1b", "fail");
        Browser.console.error('SKYHAXE_G1B_FAIL: $message');
        report('FAIL: $message', false);
        if (connection != null) connection.close();
    }
}
#end
