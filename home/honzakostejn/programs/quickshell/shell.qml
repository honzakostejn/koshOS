import "root:modules/"
import Quickshell

Scope {
  id: rootScope
  property int barHeight: 20

  BarModule {
    barHeight: rootScope.barHeight
  }
  BackgroundModule {
    barHeight: rootScope.barHeight
  }
}