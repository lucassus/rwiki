Ext.ns('Rwiki.Search');

Rwiki.Search.Window = Ext.extend(Ext.Window, {

  constructor: function() {
    var search = new Ext.form.ComboBox({
      store: this._getDataStore(),
      tpl: this._getResultTemplate(),

      minChars: 2,
      displayField: 'title',
      typeAhead: false,
      loadingText: 'Searching...',
      hideTrigger: true,
      itemSelector: 'div.search-item',
      listeners: {
        scope: this,
        select: this.onSelectResult
      }
    });

    Ext.apply(this, {
      maximizable: false,
      modal: true,
      width: 600,
      layout: 'fit',
      plain: true,
      bodyStyle: 'padding: 5px;',
      items: [search],
      defaultButton: search
    });

    Rwiki.Search.Window.superclass.constructor.apply(this, arguments);
  },

  onSelectResult: function(combo, record) {
    var path = record.data.path;
    Rwiki.openPage(path);

    this.close();
  }
});
