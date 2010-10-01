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
    this.on('pageSelected', function(path) {
      var tab = this.findOrCreatePageTab(path);
      tab.show();
    }),

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
      var oldPath = data.oldPath;
      var path = data.path;
      var title = data.title;

      var isPage = oldPath.match(new RegExp('\.txt$'));
      if (isPage) {
        // rename page
        var tab = this.findTabByPagePath(oldPath);
        if (tab == null) return;
        
        tab.setPagePath(path);
        tab.setTitle(title);
      } else {
        // rename folder
        var tabs = this.findTabsByParentPath(oldPath);
        for (var i = 0; i < tabs.length; i++) {
          var tab = tabs[i];
          var newPath = tab.getPagePath().replace(oldPath, path);
          tab.setPagePath(newPath);
        }
      }
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
    var parentPathParts = parentPath.split('/');

    return this.findBy(function() {
      var path = this.getPagePath();
      var pathParts = path.split('/');

      var result = true;
      var n = Math.min(parentPathParts.length, pathParts.length);
      for (var i = 0; i < n; i++) {
        if (parentPathParts[i] != pathParts[i]) {
          result = false;
          break;
        }
      }

      return result;
    });
  }
});
