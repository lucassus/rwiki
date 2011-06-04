Ext.ns('Rwiki');

Rwiki.EditorWindow = Ext.extend(Ext.Window, {
  constructor: function() {
    this.editorPanel = new Rwiki.Editor.Panel();
    this._container = Ext.get('editor-container');

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

  initEvents: function() {
    Rwiki.EditorWindow.superclass.initEvents.apply(this, arguments);

    this.relayEvents(Rwiki.Data.PageManager.getInstance(), ['rwiki:pageLoaded', 'rwiki:pageSaved']);
    this.on('rwiki:pageLoaded', this.onPageLoaded);
    this.on('rwiki:pageSaved', this.onPageLoaded);
  },

  setPagePath: function(path) {
    this.pagePath = path;
    this.setTitle('Editing page ' + path);
  },

  show: function() {
    Rwiki.EditorWindow.superclass.show.apply(this, arguments);

    Rwiki.mask.on(this._container).loadingPage(this.pagePath);
    this._disableButtons();

    Rwiki.Data.PageManager.getInstance().loadPage(this.pagePath);
  },

  onPageLoaded: function() {
    Rwiki.mask.on(this._container).hide();
    this._enableButtons();
  },

  savePage: function() {
    Rwiki.Data.PageManager.getInstance().savePage(this.pagePath, this.editorPanel.getContent());
    this.editorPanel.updateOldContent();
  },

  onSaveButton: function() {
    Rwiki.mask.savingPage(this.pagePath);

    this.savePage();
    this.hide();
  },

  onSaveAndContinueButton: function() {
    Rwiki.mask.on(this._container).savingPage(this.pagePath);

    this._disableButtons();
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
  },

  _disableButtons: function() {
    this._eachButton(function(button) {
      button.setDisabled(true);
    });
  },

  _enableButtons: function() {
    this._eachButton(function(button) {
      button.setDisabled(false);
    });
  },

  _eachButton: function(callback) {
    Ext.each(this.buttons, function(button) {
      callback(button);
    });
  }
});
