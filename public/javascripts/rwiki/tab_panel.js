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

  updateOrCreateTab: function(fileName, data) {
    var nodeId = Rwiki.escapedId(fileName);
    $(nodeId).html(data.html);

    var currentTab = this.getTabByFileName(fileName);
    if (!currentTab) {

      var pagePanel = new Ext.Container({
        closable: true,
        id: fileName,
        title: fileName,
        cls: 'page-container',
        iconCls: 'icon-page'
      });

      this.add(pagePanel).show();
    } else {
      currentTab.show();
    }
  },

  getTabByFileName: function(id) {
    return this.find('id', id)[0];
  }
});
