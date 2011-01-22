Ext.ns('Rwiki');

Rwiki.TabPanel = Ext.extend(Ext.TabPanel, {
  initComponent: function() {
    Ext.applyIf(this, {
      region: 'center',
      deferredRender: false,
      activeTab: 0,
      enableTabScroll: true,
      defaults: {
        autoScroll: true
      },
      plugins: new Ext.ux.TabCloseMenu(),
      tbar: [{
        text: 'Edit the page',
        scope: this,
        handler: this.onEditPage,
        iconCls: 'icon-edit'
      }]
    });

    Rwiki.TabPanel.superclass.initComponent.apply(this, arguments);
  },

  initEvents: function() {
    Rwiki.TabPanel.superclass.initEvents.apply(this, arguments);

    this.addEvents('rwiki:editPage');

    this.on('pageSelected', this.onPageSelected),
    this.on('tabchange', this.onTabChange);

    this.on('rwiki:pageCreated', this.onPageCreated);
    this.on('rwiki:pageLoaded', this.onPageLoaded);
    this.on('rwiki:pageSaved', this.onPageSaved);
    this.on('rwiki:nodeRenamed', this.onNodeRanamed);
    this.on('rwiki:nodeDeleted', this.onNodeDeleted);
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
    return this.findBy(function() {
      var path = this.getPagePath();
      return Rwiki.NodeManager.getInstance().isParent(parentPath, path);
    });
  },

  onPageSelected: function(path) {
    var tab = this.findOrCreatePageTab(path);
    tab.show();
  },

  onTabChange: function(panel, tab) {
    if (tab) {
      Ext.History.add(tab.getPagePath());
      document.title = 'Rwiki ' + tab.getPagePath();
      Rwiki.NodeManager.getInstance().loadPage(tab.getPagePath());
    } else {
      document.title = 'Rwiki';
      Rwiki.NodeManager.getInstance().fireEvent('rwiki:lastPageClosed');
    }
  },

  onPageCreated: function(data) {
    var tab = this.createPageTab(data.path, data.text);
    tab.show();
  },

  onPageLoaded: function(data) {
    var tab = this.findOrCreatePageTab(data.path);
    var title = data.baseName.replace(new RegExp('\.txt$'), '');
    
    tab.setTitle(title);
    tab.setContent(data.htmlContent);
    tab.show();
  },

  onPageSaved: function(data) {
    var tab = this.findTabByPagePath(data.path);
    if (tab == null) return;

    tab.setContent(data.htmlContent);
  },

  onNodeRanamed: function(data) {
    var oldPath = data.oldPath;
    var path = data.path;

    var currentTab = this.getActiveTab();

    var tab = null;
    var isPage = oldPath.match(new RegExp('\.txt$'));
    if (isPage) {
      tab = this.findTabByPagePath(oldPath);
      if (tab == null) return;

      tab.setPagePath(path);
      var title = data.baseName.replace(new RegExp('\.txt$'), '');
      tab.setTitle(title);

      if (tab == currentTab) {
        document.title = 'Rwiki ' + path;
      }
    } else {
      var tabs = this.findTabsByParentPath(oldPath);
      for (var i = 0; i < tabs.length; i++) {
        tab = tabs[i];
        var newPath = tab.getPagePath().replace(oldPath, path);
        tab.setPagePath(newPath);

        if (tab == currentTab) {
          document.title = 'Rwiki ' + newPath;
        }
      }
    }
  },

  onNodeDeleted: function(data) {
    var tabs = this.findTabsByParentPath(data.path);
    for (var i = 0; i < tabs.length; i++) {
      var tab = tabs[i];
      this.remove(tab);
    }
  },

  onEditPage: function() {
    var currentTab = this.getActiveTab();
    if (currentTab) {
      this.fireEvent('rwiki:editPage', currentTab.getPagePath());
    }
  }
});
