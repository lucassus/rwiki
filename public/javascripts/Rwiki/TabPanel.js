Ext.ns('Rwiki');

Rwiki.TabPanel = Ext.extend(Ext.TabPanel, {
  initComponent: function() {
    this.editPageButton = new Ext.Button({
      text: 'Edit page',
      iconCls: 'icon-edit',
      scope: this,
      handler: this.onEditPage,
      disabled: true
    });

    this.printPageButton = new Ext.Button({
      text: 'Print page',
      iconCls: 'icon-print',
      scope: this,
      handler: this.onPrint,
      disabled: true
    });

    this.findPageButton = new Ext.Button({
      text: 'Find page',
      iconCls: 'icon-search',
      scope: this,
      handler: this.onFuzzyFinder
    });

    Ext.applyIf(this, {
      region: 'center',
      deferredRender: false,
      activeTab: 0,
      enableTabScroll: true,
      defaults: {
        autoScroll: true
      },
      plugins: new Ext.ux.TabCloseMenu(),
      tbar: [this.editPageButton, this.printPageButton, this.findPageButton]
    });

    Rwiki.TabPanel.superclass.initComponent.apply(this, arguments);
  },

  initEvents: function() {
    Rwiki.TabPanel.superclass.initEvents.apply(this, arguments);

    this.addEvents('rwiki:editPage');

    this.on('rwiki:pageSelected', this.onPageSelected),
    this.on('tabchange', this.onTabChange);

    this.on('rwiki:pageCreated', this.onPageCreated);
    this.on('rwiki:pageLoaded', this.onPageLoaded);
    this.on('rwiki:lastPageClosed', this.onLastPageClosed);
    this.on('rwiki:pageSaved', this.onPageSaved);
    this.on('rwiki:pageRenamed', this.onNodeRenamed);
    this.on('rwiki:pageDeleted', this.onNodeDeleted);

    this.relayEvents(Rwiki.Data.PageManager.getInstance(), [
      'rwiki:pageLoaded',
      'rwiki:pageCreated',
      'rwiki:lastPageClosed',
      'rwiki:pageSaved',
      'rwiki:pageRenamed',
      'rwiki:pageDeleted']);
  },

  findOrCreatePageTab: function(page) {
    var tab = this.findTabByPagePath(page.getPath());
    
    if (!tab) {
      tab = this.createPageTab(page);
    } 

    return tab;
  },

  createPageTab: function(page) {
    var tab = new Rwiki.Tabs.PageTab({
      title: page.getTitle()
    });

    tab.setPagePath(page.getPath());
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
      return Rwiki.Data.PageManager.getInstance().isParent(parentPath, path);
    });
  },

  onPageSelected: function(page) {
    var tab = this.findOrCreatePageTab(page);
    tab.show();
  },

  onTabChange: function(panel, tab) {
    if (tab) {
      if (tab.isLoading()) {
        return;
      }

      Ext.History.add(tab.getPagePath());
      document.title = 'Rwiki ' + tab.getPagePath();
      Rwiki.Data.PageManager.getInstance().loadPage(tab.getPagePath());
      tab.setIsLoading(true);
    } else {
      document.title = 'Rwiki';
      Rwiki.Data.PageManager.getInstance().fireEvent('rwiki:lastPageClosed');
    }
  },

  onPageCreated: function(page) {
    var tab = this.createPageTab(page);
    tab.show();
  },

  onPageLoaded: function(page) {
    var tab = this.findOrCreatePageTab(page);

    tab.setTitle(page.getTitle());
    tab.setContent(page.getHtmlContent());
    tab.show();

    tab.setIsLoading(false);
    
    this.editPageButton.setDisabled(false);
    this.printPageButton.setDisabled(false);
  },

  onLastPageClosed: function() {
    this.editPageButton.setDisabled(true);
    this.printPageButton.setDisabled(true);
  },

  onPageSaved: function(page) {
    var tab = this.findTabByPagePath(page.getPath());
    if (tab == null) return;

    tab.setContent(page.getHtmlContent());
  },

  onNodeRenamed: function(page) {
    var oldPath = page.getData().oldPath;
    var currentTab = this.getActiveTab();

    var tab = null;
    var isPage = oldPath.match(new RegExp('\.txt$'));
    if (isPage) {
      tab = this.findTabByPagePath(oldPath);
      if (tab == null) return;

      tab.setPagePath(page.getPath());
      tab.setTitle(page.getTitle());

      if (tab == currentTab) {
        document.title = 'Rwiki ' + page.getPath();
      }
    } else {
      var tabs = this.findTabsByParentPath(oldPath);
      for (var i = 0; i < tabs.length; i++) {
        tab = tabs[i];
        var newPath = tab.getPagePath().replace(oldPath, page.getPath());
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
  },

  onFuzzyFinder: function() {
    var fuzzyFinder = new Rwiki.FuzzyFinderWindow();
    fuzzyFinder.show();
  },

  onPrint: function() {
    var currentTab = this.getActiveTab();
    if (currentTab) {
      var path = currentTab.getPagePath();
      window.open('/node/print?path=' + path, 'Rwiki ' + path, 'width=800,height=600,scrollbars=yes')
    }
  }
});
