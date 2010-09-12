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

  updateOrCreateTab: function(pageName, htmlContent) {
    var nodeId = Rwiki.escapedId(pageName);
    $(nodeId).html(htmlContent);

    var tab = this.findTabByPageName(pageName);
    if (!tab) {
      var pagePanel = new Ext.Container({
        closable: true,
        id: pageName,
        title: pageName,
        cls: 'page-container',
        iconCls: 'icon-page'
      });

      var newTab = this.add(pagePanel);
      newTab.show();
    } else {
      tab.show();
    }
  },

  findTabByPageName: function(id) {
    return this.find('id', id)[0];
  }
});
