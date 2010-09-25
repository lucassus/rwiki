Ext.ns('Rwiki');

Rwiki.rootFolderName = '.';
Rwiki.currentPageName = null;

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var treePanel = new Rwiki.TreePanel();
  var tabPanel = new Rwiki.TabPanel();
  var editorPanel = new Rwiki.EditorPanel();

  var editor = editorPanel.getEditor();
  editor.relayEvents(tabPanel, ['pageContentLoaded']);
  tabPanel.relayEvents(editor, ['pageContentChanged']);
  tabPanel.relayEvents(treePanel, ['pageChanged']);

  // Create layout

  // TODO: promote to class
  var sidePanel = new Ext.Panel({
    region: 'west',
    id: 'west-panel',
    title: 'Pages',
    split: true,
    width: 265,
    minSize: 265,
    maxSize: 500,
    collapsible: true,
    autoScroll: true,
    margins: '0 0 5 5',
    cmargins: '0 0 0 0',
    items: [treePanel]
  });

  var mainPanel = new Ext.Panel({
    region: 'center',
    layout: 'border',
    items: [tabPanel, editorPanel]
  });

  var app = new Rwiki.Viewport({
    items: [sidePanel, mainPanel],
    renderTo: Ext.getBody()
  });

  app.show();

});
