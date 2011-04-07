Ext.ns('Rwiki.Search');

Rwiki.Search.TextSearchWindow = Ext.extend(Rwiki.Search.Window, {
  constructor: function() {
    Rwiki.Search.TextSearchWindow.superclass.constructor.apply(this, [{
      title: 'Text search'
    }]);
  },

  _getDataStore: function() {
    return new Ext.data.Store({
      proxy: new Ext.data.HttpProxy({
        method: 'GET',
        url: '/text_search'
      }),

      reader: new Ext.data.JsonReader({
        root: 'results',
        totalProperty: 'count'
      }, [
        {name: 'path', mapping: 'path'},
        {name: 'line', mapping: 'line'}
      ])
    });
  },

  // Custom rendering Template
  _getResultTemplate: function() {
    return new Ext.XTemplate(
      '<tpl for="."><div class="search-item">',
        '{path}: {line}',
      '</div></tpl>'
    );
  }
});
