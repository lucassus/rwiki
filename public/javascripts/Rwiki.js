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
  Rwiki.ajaxCallCompleted = false;
  Rwiki.treeLoaded = false;

  $(document).ajaxStart(function() {
    Rwiki.ajaxCallCompleted = false;
  }).ajaxStop(function() {
    Rwiki.ajaxCallCompleted = true;

    if (firstLoad) {
      Rwiki.treePanel.openNodeFromLocationHash();
      firstLoad = false;
    }
  });

  var toolbar = new Rwiki.Toolbar();
  var treePanel = new Rwiki.TreePanel();
  Rwiki.treePanel = treePanel;
  var treePanelContextMenu = new Rwiki.TreePanel.Menu();
  treePanel.setContextMenu(treePanelContextMenu);
  var nodeManager = Rwiki.NodeManager.getInstance();

  treePanel.relayEvents(nodeManager,
    ['rwiki:pageLoaded', 'rwiki:folderCreated', 'rwiki:pageCreated', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted']);

  var tabPanel = new Rwiki.TabPanel();
  Rwiki.tabPanel = tabPanel;
  tabPanel.relayEvents(nodeManager,
    ['rwiki:pageLoaded', 'rwiki:folderCreated', 'rwiki:pageCreated', 'rwiki:pageSaved', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted']);
  tabPanel.relayEvents(treePanel, ['pageSelected']);

  var editorPanel = new Rwiki.EditorPanel();
  editorPanel.relayEvents(nodeManager,
    ['rwiki:pageLoaded', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted', 'rwiki:lastPageClosed']);
  editorPanel.relayEvents(toolbar, ['editorToggled']);

  // Handle this change event in order to restore the UI to the appropriate history state
  Ext.History.on('change', function() {
    Rwiki.treePanel.openNodeFromLocationHash();
  });

  // Create layout

  var sidePanel = new Rwiki.SidePanel({
    items: [treePanel]
  });

  sidePanel.relayEvents(toolbar, ['treeToggled']);

  var pageAndEditorPanel = new Ext.Panel({
    layout: 'border',
    region: 'center',
    items: [tabPanel, editorPanel]
  });

  var mainPanel = new Ext.Panel({
    layout: 'border',
    region: 'center',
    tbar: toolbar,
    items: [sidePanel, pageAndEditorPanel]
  });

  var app = new Rwiki.Viewport({
    items: [mainPanel]
  });

  app.show();
};
