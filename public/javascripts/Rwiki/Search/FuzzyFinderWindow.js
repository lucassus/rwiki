Ext.ns('Rwiki.Search');

Rwiki.Search.FuzzyFinderWindow = Ext.extend(Rwiki.Search.Window, {
  constructor: function() {
    Rwiki.Search.FuzzyFinderWindow.superclass.constructor.apply(this, [{
      title: 'FuzzyFinder'
    }]);
  },

  _getDataStore: function() {
    return new Ext.data.Store({
      proxy: new Ext.data.HttpProxy({
        method: 'GET',
        url: '/fuzzy_finder'
      }),

      reader: new Ext.data.JsonReader({
        root: 'results',
        totalProperty: 'count',
        id: 'path'
      }, [
        {name: 'path', mapping: 'path'},
        {name: 'score', mapping: 'score'},
        {name: 'highlighted_path', mapping: 'highlighted_path'}
      ])
    });
  },

  // Custom rendering Template
  _getResultTemplate: function() {
    return new Ext.XTemplate(
      '<tpl for="."><div class="search-item">',
        '{highlighted_path}',
      '</div></tpl>'
    );
  }
});
