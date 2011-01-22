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

  var treePanel = new Rwiki.TreePanel();
  Rwiki.treePanel = treePanel;
  var nodeManager = Rwiki.NodeManager.getInstance();

  nodeManager.on('rwiki:beforePageLoad', function() {
    Rwiki.ajaxCallCompleted = false;
  });

  nodeManager.on('rwiki:pageLoaded', function() {
    Rwiki.ajaxCallCompleted = true;
  });

  treePanel.getLoader().on('load', function() {
    Rwiki.treeLoaded = true;
    Rwiki.treePanel.openNodeFromLocationHash();
  });

  treePanel.relayEvents(nodeManager,
    ['rwiki:pageLoaded', 'rwiki:folderCreated', 'rwiki:pageCreated', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted']);

  var tabPanel = new Rwiki.TabPanel();
  Rwiki.tabPanel = tabPanel;
  tabPanel.relayEvents(nodeManager,
    ['rwiki:pageLoaded', 'rwiki:folderCreated', 'rwiki:pageCreated', 'rwiki:pageSaved', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted']);
  tabPanel.relayEvents(treePanel, ['pageSelected']);

//  var editorPanel = new Rwiki.EditorPanel();
//  editorPanel.relayEvents(nodeManager,
//    ['rwiki:pageLoaded', 'rwiki:nodeRenamed', 'rwiki:nodeDeleted', 'rwiki:lastPageClosed']);

  // Handle this change event in order to restore the UI to the appropriate history state
  Ext.History.on('change', function() {
    Rwiki.treePanel.openNodeFromLocationHash();
  });

  // Create layout

  var app = new Ext.Viewport({
    layout: 'border',
    renderTo: Ext.getBody(),
    items: [treePanel, tabPanel]
  });

  app.show();
};
