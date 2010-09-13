Rwiki.TabPanel = Ext.extend(Ext.TabPanel, {
  constructor: function(config) {
    config = Ext.apply({
      region: 'center',
      deferredRender: false,
      activeTab: 0,
      resizeTabs: true,
      minTabWidth: 200,
      enableTabScroll: true,
      defaults: {
        autoScroll: true
      },
      plugins: new Ext.ux.TabCloseMenu()
    }, config);

    Rwiki.TabPanel.superclass.constructor.call(this, config);
  },

  updateOrAddPage: function(pageName, htmlContent) {
    var tab = this.findTabByPageName(pageName);
    if (!tab) {
      tab = this.addPage(pageName);
    } 

    tab.setContent(htmlContent);
    return tab.show();
  },

  addPage: function(pageName) {
    var pagePanel = new Rwiki.TabPanel.PageTab({
      id: pageName,
      title: pageName
    });

    return this.add(pagePanel);
  },

  closeRelatedTabs: function(node) {
    var self = this;
    node.cascade(function() {
      var pageName = this.getPageName();
      var tab = self.findTabByPageName(pageName);
      if (tab) {
        self.remove(tab);
      }
    });
  },

  findTabByPageName: function(id) {
    return this.find('id', id)[0];
  }
});
