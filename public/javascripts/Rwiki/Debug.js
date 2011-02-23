Ext.ns('Rwiki');

Rwiki.Debug = {

  /**
   * Log the event names to the console of any observable object.
   */
  captureEvents: function(observable) {
    Ext.util.Observable.capture(observable, function(eventName, data) {
      if (!window.console) return;

      console.log(data);
      console.log(eventName);
    });
  },

  emulateSlowConnection: function(emulate) {
    Ext.Ajax.extraParams = { emulateSlowConnection: emulate };
  }

};
