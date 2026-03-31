pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Wayland

Singleton {
  id: idle

  property bool respectInhibs: true
  property bool lockOn: true
  property int  lockSec: 300
  property bool dpmsOn: true
  property int  dpmsSec: 30
  property bool suspendOn: false
  property int  suspendSec: 120
  property var  window

  readonly property int firstSec: lockOn ? lockSec : dpmsOn ? dpmsSec : suspendOn ? suspendSec : 0

  QtObject { id: st; property int i: -1; property var seq: [] }

  signal requestLock()
  signal requestDpmsOff()
  signal requestDpmsOn()
  signal requestSuspend()
  signal stageFired(string name)

  function build() {
    const a=[]; if (lockOn) a.push({name:"lock",delaySec:lockSec});
    if (dpmsOn) a.push({name:"dpms-off",delaySec:dpmsSec});
    if (suspendOn) a.push({name:"suspend",delaySec:suspendSec});
    return a;
  }

  function start() { if (st.i!==-1) return; st.seq=build(); st.i=-1; next(); }

  function next() {
    if (++st.i>=st.seq.length) return;
    const x=st.seq[st.i], ms=((x.delaySec||0)*1000)|0;
    if (ms>0) { tm.interval=ms; tm.restart(); } else Qt.callLater(idle.run);
  }

  function run() {
    const x=st.seq[st.i]; if (!x) return;
    if (x.name==="lock") requestLock();
    else if (x.name==="dpms-off") requestDpmsOff();
    else if (x.name==="suspend") requestSuspend();
    stageFired(x.name); next();
  }

  function cancel() { tm.stop(); st.i=-1; }
  function wake() { cancel(); requestDpmsOn(); }

  IdleMonitor {
    enabled: idle.lockOn || idle.dpmsOn || idle.suspendOn
    respectInhibitors: idle.respectInhibs
    timeout: idle.firstSec
    onIsIdleChanged: isIdle ? Qt.callLater(idle.start) : Qt.callLater(idle.cancel)
  }

  IdleInhibitor { enabled: idle.respectInhibs; window: idle.window }

  Timer { id: tm; repeat: false; onTriggered: idle.run() }
}
