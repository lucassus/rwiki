Ext.ns('Rwiki');

Rwiki.rootFolderName = '.';
Rwiki.nodeManager = new Rwiki.Node();

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
  Rwiki.captureEvents(Rwiki.nodeManager);

  var treePanel = new Rwiki.TreePanel();
  treePanel.relayEvents(Rwiki.nodeManager,
    ['folderCreated', 'pageCreated', 'nodeRenamed', 'nodeDeleted']);

  var tabPanel = new Rwiki.TabPanel();
  tabPanel.relayEvents(Rwiki.nodeManager,
    ['pageLoaded', 'folderCreated', 'pageCreated', 'pageSaved', 'nodeRenamed', 'nodeDeleted']);
  tabPanel.relayEvents(treePanel, ['pageSelected']);

  var editorPanel = new Rwiki.EditorPanel();
  editorPanel.relayEvents(Rwiki.nodeManager,
    ['pageLoaded', 'nodeRenamed', 'nodeDeleted']);

  // Create layout

  var sidePanel = new Rwiki.SidePanel({
    items: [treePanel]
  });

  var toggleTreePanelAction = new Ext.Action({
    text: 'Toggle tree',
    handler: function() {
      sidePanel.toggleCollapse();
    }
  });

  var toggleEditorAction = new Ext.Action({
    text: 'Toggle editor',
    handler: function() {
      editorPanel.toggleCollapse();
    }
  });

  var toolbar = new Rwiki.Toolbar({
    items: [toggleTreePanelAction, toggleEditorAction]
  });

  var mainPanel = new Ext.Panel({
    region: 'center',
    layout: 'border',
    tbar: toolbar,
    items: [tabPanel, editorPanel]
  });

  var app = new Rwiki.Viewport({
    items: [sidePanel, mainPanel],
    renderTo: Ext.getBody()
  });

  app.show();
};
