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

  addFileTab: function(id, html) {
    var currentTab = this.find('id', id)[0];
    if (!currentTab) {
      var pagePanel = new Ext.Container({
        closable: true,
        id: id,
        title: id.replace(/-/g, '/'),
        iconCls: 'tabs',
        html: html
      });

      this.add(pagePanel).show();
    } else {
      currentTab.show();
    }
  }
});
