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

  updateOrCreateTab: function(fileName, htmlContent) {
    var nodeId = Rwiki.escapedId(fileName);
    $(nodeId).html(htmlContent);

    var tab = this.findTabByFileName(fileName);
    if (!tab) {
      var pagePanel = new Ext.Container({
        closable: true,
        id: fileName,
        title: fileName,
        cls: 'page-container',
        iconCls: 'icon-page'
      });

      var newTab = this.add(pagePanel);
      newTab.show();
    } else {
      tab.show();
    }
  },

  findTabByFileName: function(id) {
    return this.find('id', id)[0];
  }
});
