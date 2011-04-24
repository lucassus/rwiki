Ext.ns('Rwiki');

Rwiki.EditorWindow = Ext.extend(Ext.Window, {
  constructor: function() {
    this.editorPanel = new Rwiki.Editor.Panel();

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
      buttons: [new Rwiki.Button({
        text: 'Save',
        scope: this,
        handler: this.onSaveButton,
        iconCls: 'icon-save'
      }), new Rwiki.Button({
        text: 'Save and continue',
        scope: this,
        handler: this.onSaveAndContinueButton,
        iconCls: 'icon-save'
      }), new Rwiki.Button({
        text: 'Cancel',
        scope: this,
        handler: this.onCancelButton,
        iconCls: 'icon-cancel'
      })]
    });

    Rwiki.EditorWindow.superclass.constructor.apply(this, arguments);
  },

  setPagePath: function(path) {
    this.pagePath = path;
    this.setTitle('Editing page ' + path);
  },

  show: function() {
    Rwiki.Data.PageManager.getInstance().loadPage(this.pagePath);
    Rwiki.EditorWindow.superclass.show.apply(this, arguments);

    Ext.get('editor-container').mask('Loading the page...');
  },

  savePage: function() {
    Rwiki.Data.PageManager.getInstance().savePage(this.pagePath, this.editorPanel.getContent());
  },

  onSaveButton: function() {
    this.savePage();
    this.hide();
  },

  onSaveAndContinueButton: function() {
    this.savePage();
  },

  onCancelButton: function() {
    this._exitEditor();
  },

  close: function() {
    this._exitEditor();
  },

  _exitEditor: function() {
    if (!this.editorPanel.isContentChanged() || confirm('Content has been changes, continue?')) {
      this.hide();
    }
  }
});
