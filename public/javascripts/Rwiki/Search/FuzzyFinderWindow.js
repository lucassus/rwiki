Ext.ns('Rwiki.Search');

Rwiki.Search.FuzzyFinderWindow = Ext.extend(Ext.Window, {
  constructor: function() {
    var self = this;

    var dataStore = new Ext.data.Store({
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

    // Custom rendering Template
    var resultTpl = new Ext.XTemplate(
      '<tpl for="."><div class="search-item">',
        '{highlighted_path}',
      '</div></tpl>'
    );

    var search = new Ext.form.ComboBox({
      store: dataStore,
      minChars: 2,
      displayField: 'title',
      typeAhead: false,
      loadingText: 'Searching...',
      hideTrigger: true,
      tpl: resultTpl,
      itemSelector: 'div.search-item',
      onSelect: function(record) { 
        var path = record.data.path;
        Rwiki.openPage(path);
        self.close();
      }
    });

    Ext.apply(this, {
      title: 'FuzzyFinder',
      maximizable: false,
      modal: true,
      width: 600,
      layout: 'fit',
      plain: true,
      bodyStyle: 'padding: 5px;',
      items: [search],
      defaultButton: search
    });

    Rwiki.Search.FuzzyFinderWindow.superclass.constructor.apply(this, arguments);
  }
});
