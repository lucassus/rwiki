Ext.ns('Rwiki');

// TODO fetch if from the configuration
Rwiki.rootFolderName = 'Home';

Rwiki.loadPageFromLocation = function() {
  if (!location.hash) return;
  var path = location.hash.replace(new RegExp('^#'), '');
  Rwiki.openPage(path);
};

Rwiki.openPage = function(path) {
  var node = Rwiki.treePanel.findNodeByPath(path);
  if (node) {
    Rwiki.treePanel.onClick(node);
  }
};

Rwiki.setAppTitle = function(title) {
  document.title = 'Rwiki ' + title;
};

Rwiki.updateToc = function(htmlToc) {
  $('div#toc-container').html(htmlToc);
};

Rwiki.init = function() {

  // TabPanel history
  Ext.History.init();

  Rwiki.treePanel = new Rwiki.TreePanel();
  Rwiki.nodeManager = Rwiki.Data.PageManager.getInstance();
  Rwiki.Debug.captureEvents(Rwiki.nodeManager);

  Rwiki.nodeManager.on('rwiki:beforePageLoad', function() {
    Rwiki.statusBar.showBusy();
  });

  Rwiki.nodeManager.on('rwiki:pageLoaded', function(page) {
    Rwiki.updateToc(page.getHtmlToc());
    Rwiki.statusBar.clearStatus({useDefaults: true});
  });

  Rwiki.nodeManager.on('rwiki:pageSaved', function(page) {
    Rwiki.updateToc(page.getHtmlToc());
  });

  Rwiki.statusBar = new Ext.ux.StatusBar({
    statusAlign: 'right',
    defaultText: 'Ready',
    iconCls: 'x-status-valid'
  });

  // Initialize the internal links
  $('a.internal-link').live('click', function() {
    var path = $(this).attr('href');
    var node = Rwiki.treePanel.findNodeByPath(path);
    if (node) {
      Rwiki.treePanel.onClick(node);
    }

    return false;
  });

  Rwiki.tabPanel = new Rwiki.TabPanel({
    bbar: Rwiki.statusBar
  });
  Rwiki.tabPanel.relayEvents(Rwiki.treePanel, ['rwiki:pageSelected']);

  var editorWindow = new Rwiki.EditorWindow();
  Rwiki.tabPanel.on('rwiki:editPage', function(path) {
    if (!editorWindow.isVisible()) {
      editorWindow.setPagePath(path);
      editorWindow.show();
    }
  });

  Ext.History.on('change', function() {
    Rwiki.loadPageFromLocation();
  });

  // Create the layout

  var tocPanel = {
    id: 'toc-panel',
    title: 'Table of Content',
    region: 'center',
    bodyStyle: 'padding-bottom:15px;background:#eee;',
    autoScroll: true,
    html: '<div id="toc-container">When you select a page from the tree, the TOC will display here.</div>'
  };

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
      items: [Rwiki.treePanel, tocPanel]
    }, Rwiki.tabPanel],
    listeners: {
      afterrender: function() {
        Rwiki.treePanel.root.expand();
        Rwiki.loadPageFromLocation();
      }
    }
  });

  appViewport.show();

  // map one key by key code
  var map = new Ext.KeyMap(document, [{
    key: "e",
    alt: true,
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onEditPage();
    }
  }, {
    key: "t",
    ctrl: true,
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onFuzzyFinder();
    }
  }, {
    key: "s",
    ctrl: true,
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.getToolbar().onTextSearch();
    }
  }, {
    key: "w",
    ctrl: true,
    stopEvent: true,
    fn: function() {
      var tab = Rwiki.tabPanel.getActiveTab();
      Rwiki.tabPanel.remove(tab);
    }
  }]);

};
