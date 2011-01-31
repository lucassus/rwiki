Ext.ns('Rwiki');

Rwiki.rootFolderName = 'Home';

/**
 * Log the event names to the console of any observable object.
 */
Rwiki.captureEvents = function(observable) {
  Ext.util.Observable.capture(observable, function(eventName) {
    if (console === undefined) return;
    console.log(eventName);
  });
};

Rwiki.init = function() {

  // TabPanel history
  Ext.History.init();

  var firstLoad = true;

  // TODO find better solution
  Rwiki.ajaxCallCompleted = true;
  Rwiki.treeLoaded = false;

  Rwiki.treePanel = new Rwiki.TreePanel();
  var nodeManager = Rwiki.NodeManager.getInstance();

  nodeManager.on('rwiki:beforePageLoad', function() {
    Rwiki.ajaxCallCompleted = false;
    Rwiki.statusBar.showBusy();
  });

  nodeManager.on('rwiki:pageLoaded', function() {
    Rwiki.ajaxCallCompleted = true;
    Rwiki.statusBar.clearStatus({useDefaults: true});
  });

  Rwiki.statusBar = new Ext.ux.StatusBar({
    statusAlign: 'right',
    defaultText: 'Ready',
    iconCls: 'x-status-valid'
  });

  Rwiki.treePanel.getLoader().on('load', function() {
    Rwiki.treeLoaded = true;
    Rwiki.treePanel.openNodeFromLocationHash();
  });

  Rwiki.tabPanel = new Rwiki.TabPanel({
    bbar: Rwiki.statusBar
  });
  Rwiki.tabPanel.relayEvents(Rwiki.treePanel, ['rwiki:pageSelected']);

  var editorPanel = new Rwiki.EditorPanel();
  var editorWindow = new Rwiki.EditorWindow(editorPanel);

  function showEditor(path) {
    if (!editorWindow.isVisible()) {
      editorWindow.setPagePath(path);
      editorWindow.show();
    }
  }

  Rwiki.tabPanel.on('rwiki:editPage', function(path) {
    showEditor(path);
  });

  // Handle this change event in order to restore the UI to the appropriate history state
  Ext.History.on('change', function() {
    Rwiki.treePanel.openNodeFromLocationHash();
  });

  // Create layout

  var navigationPanel = new Rwiki.NavigationPanel({
    items: [Rwiki.treePanel]
  });

  var app = new Ext.Viewport({
    layout: 'border',
    plain: true,
    renderTo: Ext.getBody(),
    items: [navigationPanel, Rwiki.tabPanel]
  });

  app.show();

  // map one key by key code
  var map = new Ext.KeyMap(document, [{
    key: "e",
    alt: true,
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.onEditPage();
    }
  }, {
    key: "t",
    ctrl: true,
    stopEvent: true,
    fn: function() {
      Rwiki.tabPanel.onFuzzyFinder();
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
