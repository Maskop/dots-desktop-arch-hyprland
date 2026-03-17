pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  PwObjectTracker {
    objects: sinks
  }

  readonly property var sinks: Pipewire.nodes.values.reduce((acc, node) => {
    if (!node.isStream && node.isSink && node.audio) {
      acc.push(node);
    }
    return acc;
  }, [])

  readonly property PwNode sink: {
    if (!Pipewire.ready) return null;
      
    let defaultSink = Pipewire.defaultAudioSink;
      
    if (defaultSink && !defaultSink.isStream && defaultSink.isSink && defaultSink.audio) {
      return defaultSink;
    }
      
    return sinks.length > 0 ? sinks[0] : null;
  }

  readonly property bool ready: !!sink
  readonly property real volume: sink?.audio?.volume ?? 0
  readonly property bool muted: sink?.audio?.muted ?? false
  readonly property string description: sink?.description ?? "Audio Output"
  
  readonly property int level: Math.round(volume * 100)
  readonly property string icon: {
    if (root.volume < 0.5) {
      return ""
    } else {
      return ""
    }
  }

  function toggleMute() {
    if (sink && sink.audio) {
      sink.audio.muted = !sink.audio.muted;
    }
  }
}
