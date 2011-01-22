Ext.ns('Rwiki');

Rwiki.EditorWindow = Ext.extend(Ext.Window, {
  constructor: function(editorPanel) {
    Ext.apply(this, {
      title: 'Edititing page',
      maximizable: true,
      modal: true,
      width: 750,
      height: 500,
      minWidth: 300,
      minHeight: 200,
      layout: 'fit',
      plain: true,
      bodyStyle: 'padding: 5px;',
      buttonAlign: 'center',
      items: editorPanel,
      buttons: [
        {
          text: 'Save',
          scope: this,
          handler: this.onSaveButton
        },
        {
          text: 'Save and continue',
          scope: this,
          handler: this.onSaveAndContinueButton
        },
        {
          text: 'Cancel',
          scope: this,
          handler: this.onCancelButton
        }
      ]
    });

    Rwiki.EditorWindow.superclass.constructor.apply(this, arguments);
  },

  onSaveButton: function() {
    this.hide();
  },

  onSaveAndContinueButton: function() {

  },

  onCancelButton: function() {
    this.hide();
  }
});
