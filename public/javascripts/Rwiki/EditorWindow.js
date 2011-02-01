Ext.ns('Rwiki');

Rwiki.EditorWindow = Ext.extend(Ext.Window, {
  constructor: function() {
    this.editorPanel = new Rwiki.EditorPanel();

    Ext.apply(this, {
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
      items: this.editorPanel,
      buttons: [
        {
          text: 'Save',
          scope: this,
          handler: this.onSaveButton,
          iconCls: 'icon-save'
        },
        {
          text: 'Save and continue',
          scope: this,
          handler: this.onSaveAndContinueButton,
          iconCls: 'icon-save'
        },
        {
          text: 'Cancel',
          scope: this,
          handler: this.onCancelButton,
          iconCls: 'icon-cancel'
        }
      ]
    });

    Rwiki.EditorWindow.superclass.constructor.apply(this, arguments);
  },

  setPagePath: function(path) {
    this.pagePath = path;
    this.setTitle('Editing page ' + path);
  },

  show: function() {
    Rwiki.nodeManager.loadPage(this.pagePath);
    Rwiki.EditorWindow.superclass.show.apply(this, arguments);

    Ext.get('editor-container').mask('Loading the page...');
  },

  savePage: function() {
    Rwiki.nodeManager.savePage(this.pagePath, this.editorPanel.getRawContent());
  },

  onSaveButton: function() {
    this.savePage();
    this.hide();
  },

  onSaveAndContinueButton: function() {
    this.savePage();
  },

  onCancelButton: function() {
    this.hide();
  },

  close: function() {
    this.hide();
  }
});
