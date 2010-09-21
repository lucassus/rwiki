Rwiki.TabPanel = Ext.extend(Ext.TabPanel, {
  constructor: function(config) {
    config = Ext.apply({
      region: 'center',
      deferredRender: false,
      activeTab: 0,
      enableTabScroll: true,
      defaults: {
        autoScroll: true
      },
      plugins: new Ext.ux.TabCloseMenu()
    }, config);

    Rwiki.TabPanel.superclass.constructor.call(this, config);
  },

  /**
   * @todo refactor this method
   */
  updateOrAddPageTab: function(path, htmlContent) {
    var tab = this.findTabByPagePath(path);
    if (!tab) {
      tab = this.addPageTab(path);
    } 

    if (htmlContent) {
      tab.setContent(htmlContent);
    }

    return tab;
  },

  addPageTab: function(path) {
    var pageTab = new Rwiki.TabPanel.PageTab({
      id: path,
      title: path
    });

    return this.add(pageTab);
  },

  closeRelatedTabs: function(node) {
    var self = this;
    node.cascade(function() {
      var path = this.id;
      var tab = self.findTabByPagePath(path);
      if (tab) {
        self.remove(tab);
      }
    });
  },

  findTabByPagePath: function(pageName) {
    return this.find('id', pageName)[0];
  }
});
