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

  var toolbar = new Rwiki.Toolbar();
  var treePanel = new Rwiki.TreePanel();
  var treePanelContextMenu = new Rwiki.TreePanel.Menu();
  treePanel.setContextMenu(treePanelContextMenu);
  var nodeManager = Rwiki.Node.getInstance();

  treePanel.relayEvents(nodeManager,
    ['folderCreated', 'pageCreated', 'nodeRenamed', 'nodeDeleted']);

  var tabPanel = new Rwiki.TabPanel();
  tabPanel.relayEvents(nodeManager,
    ['pageLoaded', 'folderCreated', 'pageCreated', 'pageSaved', 'nodeRenamed', 'nodeDeleted']);
  tabPanel.relayEvents(treePanel, ['pageSelected']);

  var editorPanel = new Rwiki.EditorPanel();
  editorPanel.relayEvents(nodeManager,
    ['pageLoaded', 'nodeRenamed', 'nodeDeleted', 'lastPageClosed']);
  editorPanel.relayEvents(toolbar, ['editorToggled']);

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
