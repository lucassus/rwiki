Ext.ns('Rwiki');

Rwiki.rootFolderPath = '.';
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
  treePanel.relayEvents(Rwiki.Node.getInstance(),
    ['folderCreated', 'pageCreated', 'nodeRenamed', 'nodeDeleted']);

  var tabPanel = new Rwiki.TabPanel();
  tabPanel.relayEvents(Rwiki.Node.getInstance(),
    ['pageLoaded', 'folderCreated', 'pageCreated', 'pageSaved', 'nodeRenamed', 'nodeDeleted']);
  tabPanel.relayEvents(treePanel, ['pageSelected']);

  var editorPanel = new Rwiki.EditorPanel();
  editorPanel.relayEvents(Rwiki.Node.getInstance(),
    ['pageLoaded', 'nodeRenamed', 'nodeDeleted']);
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
