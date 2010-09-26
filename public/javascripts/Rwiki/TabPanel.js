Ext.ns('Rwiki');

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
      plugins: new Ext.ux.TabCloseMenu(),
      listeners: {
        tabchange: this.onTabChange
      }
    }, config);

    Rwiki.TabPanel.superclass.constructor.call(this, config);

    this.addEvents('pageContentLoaded');

    this.on('pageContentChanged', function(data) {
      var tab = this.findTabByPagePath(data.path);
      tab.setContent(data.html);
    });

    this.on('pageCreated', function(data) {
      var path = data.path;
      var tab = this.updateOrAddPageTab(path);
      tab.show();
    });

    this.on('pageChanged', function(path) {
      var tab = this.updateOrAddPageTab(path);
      tab.show(); // it will fire the 'tabchange' event
    });

    this.on('nodeDeleted', function(node) {
      this.closeRelatedTabs(node);
    });
  },

  onTabChange: function(tabPanel, tab) {
    if (!tab) return;

    var path = tab.getPagePath();
    $.ajax({
      type: 'GET',
      url: '/node',
      dataType: 'json',
      data: {
        path: path
      },
      success: function(data) {
        tabPanel.fireEvent('pageContentLoaded', data);
      }
    });
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
    pageTab.relayEvents(this, ['pageContentLoaded']);

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
