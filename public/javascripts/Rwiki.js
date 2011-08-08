Ext.ns('Rwiki');

// TODO fetch it from the configuration
Rwiki.rootFolderName = 'Home';

Rwiki.setAppTitle = function(title) {
  document.title = 'Rwiki ' + title;
};

Rwiki.openPage = function(path) {
  path = unescape(path);
  var pageTab = Rwiki.tabPanel.findTabByPagePath(path);
  if (pageTab) {
    // page is already loaded, just show the corresponding tab
    pageTab.show();
  } else {
    Rwiki.mask.loadingPage(path);
    Rwiki.Data.PageManager.getInstance().loadPage(path);
  }
};

Rwiki.init = function() {
  Rwiki.mask = new Rwiki.Mask(Ext.getBody());
  Rwiki.flash = new Rwiki.Flash();

  Rwiki.treePanel = new Rwiki.TreePanel();
  Rwiki.nodeManager = Rwiki.Data.PageManager.getInstance();
  Rwiki.Debug.captureEvents(Rwiki.nodeManager);

  Rwiki.nodeManager.on('rwiki:beforePageLoad', function() {
    Rwiki.statusBar.showBusy();
  });

  Rwiki.nodeManager.on('rwiki:pageLoaded', function(page) {
    Rwiki.statusBar.clearStatus({useDefaults: true});
    Rwiki.mask.hide();
  });

  Rwiki.nodeManager.on('rwiki:pageNotFound', function(message) {
    Rwiki.mask.hide();
    Rwiki.flash.error(message);
  });

  Rwiki.nodeManager.on('rwiki:pageSaved', function(page) {
    Rwiki.mask.hide();
    Rwiki.flash.success('Page ' + page.getPath() + ' was saved!');
  });

  Rwiki.nodeManager.on('rwiki:pageDeleted', function(page) {
    Rwiki.mask.hide();
    Rwiki.flash.success('Page' + page.getPath() + ' was deleted!');
  });

  Rwiki.nodeManager.on('rwiki:pageCreated', function(page) {
    Rwiki.mask.hide();
    Rwiki.flash.success('Page' + page.getPath() + ' was created!');
  });

  Rwiki.nodeManager.on('rwiki:pageRenamed', function(page) {
    Rwiki.mask.hide();
    Rwiki.flash.success('Page' + page.getPath() + ' was renamed!');
    window.history.pushState({ path: page.getPath() }, '', '/page' + page.getPath());
  });

  Rwiki.statusBar = new Ext.ux.StatusBar({
    statusAlign: 'right',
    defaultText: 'Ready',
    iconCls: 'x-status-valid'
  });

  // Initialize the internal links
  $('a.internal-link').live('click', function() {
    var path = $(this).attr('href');
    Rwiki.openPage(path);
    return false;
  });

  Rwiki.tabPanel = new Rwiki.TabPanel({
    bbar: Rwiki.statusBar
  });

  var editorWindow = new Rwiki.EditorWindow();
  Rwiki.tabPanel.on('rwiki:editPage', function(path) {
    if (!editorWindow.isVisible()) {
      editorWindow.setPagePath(path);
      editorWindow.show();
    }
  });

  Rwiki.tabPanel.on('tabchange', function(panel, tab) {
    if (tab) {
      var page = tab.getPage();
      window.history.pushState({ path: page.getPath() }, '', '/page' + page.getPath());
    } else{
      window.history.pushState({}, '', '/');
    }
  });

  // Create the layout
  Rwiki.tocPanel = new Rwiki.TocPanel();

  var appViewport = new Ext.Viewport({
    layout: 'border',
    plain: true,
    renderTo: Ext.getBody(),
    items: [{
      layout: 'border',
      region: 'west',
      split: true,
      collapsible: true,
      width: 250,
      minSize: 200,
      maxSize: 500,
      items: [Rwiki.treePanel, Rwiki.tocPanel]
    }, Rwiki.tabPanel],
    listeners: {
      afterrender: function() {
        Rwiki.treePanel.root.expand();
      }
    }
  });

  appViewport.show();

  // map one key by key code
  Rwiki.keyMap = new Ext.KeyMap(document, [{
    key: "e",
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onEditPage();
    }
  }, {
    key: "t",
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onFuzzyFinder();
    }
  }, {
    key: "s",
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onTextSearch();
    }
  }, {
    key: "w",
    stopEvent: true,
    fn: function() {
      var tab = Rwiki.tabPanel.getActiveTab();
      Rwiki.tabPanel.remove(tab);
    }
  }]);

  // try to load a page from the location
  var pageRegexp = /^\/page(.*)$/;
  var pathName = window.location.pathname;
  if (pageRegexp.test(pathName)) {
    var path = pageRegexp.exec(pathName)[1];
    Rwiki.openPage(path);
  }
};
