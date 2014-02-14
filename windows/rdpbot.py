import sleekxmpp
import sys
import subprocess

# configuration
jid = 'jid@server'
password = r'password'
remote_port = 22
forwarded_port = 3389
remote_forwarded_port = 19999
remote_host = 'hostname'
ssh_cmd = 'plink'
user = 'user'

class Bot:
    def __init__(self, jid, password):
        self.xmpp = sleekxmpp.ClientXMPP(jid + '/rdpbot', password)
        self.xmpp.add_event_handler("session_start", self.session_start)
        self.xmpp.add_event_handler("message", self.message)
        self.pid = None

    def session_start(self, event):
        self.xmpp.send_presence()
        self.xmpp.boundjid.resource = 'rdpbot'

    def message(self, msg):
        if not msg['type'] in ('chat', 'normal'):
            return
        
        to = msg['from']
        cmd = msg['body']

        if cmd == 'start':
            self.start_tunnel(to)
        elif cmd == 'stop':
            self.stop_tunnel(to)
        else:
            self.log('Unknown command received: %s' % cmd, to)

    def run(self):
        print('Connecting to XMPP server...')
        self.xmpp.connect()
        print('Connected.')
        self.xmpp.process(block=True)

    def stop(self):
        self.xmpp.disconnect()

    def log(self, msg, to):
        self.xmpp.send_message(mto=to, mbody=msg)
        print(msg)

    def start_tunnel(self, to):
        if self.pid != None:
            self.log('Process already started, command ignored.', to)
        else:
            self.pid = subprocess.Popen([ssh_cmd, '-P', str(remote_port), \
                '-R', '*:%d:localhost:%d' % (remote_forwarded_port, forwarded_port), \
                '%s@%s' % (user, remote_host), \
                '-pw', '%s' % password, \
                '-N'])
            self.log('Tunnel started.', to)

    def stop_tunnel(self, to):
        if self.pid == None:
            self.log('Tunnel doesn\'t started, command ignored.', to)
        else:
            self.pid.terminate()
            self.pid = None
            self.log('Tunnel stopped.', to)

if __name__ == '__main__':
    try:
        bot = Bot(jid, password)
        bot.run()
    except KeyboardInterrupt:
        print('Interrupted.')
        bot.stop()
        sys.exit(1)
    except Exception as ex:
        print (ex)
