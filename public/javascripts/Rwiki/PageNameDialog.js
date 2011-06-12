Ext.ns('Rwiki');

Rwiki.PageNameDialog = Ext.extend(Ext.Window, {
  constructor: function() {
    this.formPanel = new Ext.FormPanel({
      labelWidth: 75,
      frame: true,
      defaultType: 'textfield',
      items: [{
        fieldLabel: 'Page name',
        name: 'page_name',
        allowBlank: false
      }],
      buttons: [{
        text: 'Ok'
      }, {
        text: 'Cancel'
      }]
    });

    Ext.apply(this, {
      title: 'Page name',
      modal: true,
      width: 280,
      height: 100,
      items: [this.formPanel]
    });

    Rwiki.PageNameDialog.superclass.constructor.apply(this, arguments);
  }
});
