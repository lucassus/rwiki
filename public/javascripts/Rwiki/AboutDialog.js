Ext.ns('Rwiki');

Rwiki.AboutDialog = Ext.extend(Ext.Window, {
  constructor: function() {
    var self = this;

    Ext.apply(this, {
      applyTo: 'about-dialog',
      width: 400,
      height: 200,
      plain: true,
      modal: true,
      closeAction: 'hide',
      items: new Ext.TabPanel({
        applyTo: 'hello-tabs',
        autoTabs: true,
        activeTab: 0,
        deferredRender: false,
        border: false
      }),
      buttons: [{
        text: 'Close',
        handler: function() {
          self.hide();
        }
      }]
    });

    Rwiki.AboutDialog.superclass.constructor.apply(this, arguments);
  }
});

