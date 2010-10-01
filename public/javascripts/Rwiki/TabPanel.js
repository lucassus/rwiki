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
      plugins: new Ext.ux.TabCloseMenu()
    }, config);

    Rwiki.TabPanel.superclass.constructor.call(this, config);
    this.initEventHandlers();
  },

  initEventHandlers: function() {
    this.on('tabchange', function(panel, tab) {
      if (tab == null) return;
      Rwiki.nodeManager.fireEvent('loadPage', tab.getPagePath());
    });

    this.on('pageCreated', function(data) {
      var tab = this.createPageTab(data.path, data.text);
      tab.show();
    });

    this.on('pageLoaded', function(data) {
      var tab = this.findOrCreatePageTab(data.path);
      tab.setTitle(data.title);
      tab.setContent(data.html);
      tab.show();
    });

    this.on('pageSaved', function(data) {
      var tab = this.findTabByPagePath(data.path);
      if (tab == null) return;
      tab.setContent(data.html);
    });

    this.on('nodeRenamed', function(data) {
      var tab = this.findTabByPagePath(data.oldPath);
      if (tab == null) return;

      tab.setPagePath(data.path);
      tab.setTitle(data.title);
    });

    this.on('nodeDeleted', function(data) {
      var tabs = this.findTabsByParentPath(data.path);
      for (var i = 0; i < tabs.length; i++) {
        var tab = tabs[i];
        this.remove(tab);
      }
    });
  },

  findOrCreatePageTab: function(path) {
    var tab = this.findTabByPagePath(path);
    
    if (!tab) {
      tab = this.createPageTab(path);
    } 

    return tab;
  },

  createPageTab: function(path, title) {
    var tab = new Rwiki.TabPanel.PageTab({
      title: title
    });

    tab.setPagePath(path);
    this.add(tab);
    
    return tab;
  },

  findTabByPagePath: function(pagePath) {
    return this.findBy(function() {
      return this.getPagePath() == pagePath;
    })[0];
  },

  findTabsByParentPath: function(parentPath) {
    var re = new RegExp('^' + parentPath);
    return this.findBy(function() {
      var path = this.getPagePath();
      return path.match(re) != null;
    });
  }
});
