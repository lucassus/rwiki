Ext.ns('Rwiki');

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var editor = new Rwiki.Editor($('textarea#editor'));
  var tabPanel = new Rwiki.TabPanel();
  tabPanel.setEditor(editor);

  var treePanel = new Rwiki.TreePanel();
  treePanel.setTabPanel(tabPanel);

  var leftPanel = new Ext.Panel({
    region: 'west',
    id: 'west-panel',
    title: 'Pages',
    split: true,
    collapsible: true,
    width: 200,
    minSize: 175,
    maxSize: 400,
    margins: '0 0 0 5',
    items: [treePanel]
  });

  var editorPanel = new Ext.Panel({
    region: 'south',
    contentEl: 'edit-container',
    title: 'Editor',
    split: true,
    collapsible: true,
    collapseMode: 'mini',
    height: 400
  });

  var pagePanel = new Ext.Container({
    region: 'center',
    layout: 'border',
    items: [tabPanel, editorPanel]
  });

  new Ext.Viewport({
    layout: 'border',
    items: [leftPanel, pagePanel]
  });

});
