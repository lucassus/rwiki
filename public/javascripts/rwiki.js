Ext.ns('Rwiki');

Rwiki.rootDirName = '.';

/**
 * Escapes any non-words characters.
 * Used for generating elements ids for jQuery selectors.
 * @returs escaped node id
 */
Rwiki.escapedId = function(id) {
  return '#' + id.replace(/(\W)/g, '\\$1');
};

Rwiki.loadNode = function(fileName) {
  var nodeData = {};

  $.ajax({
    async: false,
    type: 'GET',
    url: '/node/content',
    dataType: 'json',
    data: {
      fileName: fileName
    },
    success: function(data) {
      nodeData = data;
    }
  });

  return nodeData;
};

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var treePanel = new Rwiki.TreePanel();
  var tabPanel = new Rwiki.TabPanel();
  var editorPanel = new Rwiki.EditorPanel();

  tabPanel.on('tabchange', function(tabPanel, tab) {
    var lastTabClosed = !tab;
    
    if (!lastTabClosed) {
      var fileName = tab.id;
      var nodeData = Rwiki.loadNode(fileName);

      editorPanel.editor.setContent(nodeData.raw);
      tabPanel.updateOrCreateTab(fileName, nodeData);

    } else {
      editorPanel.editor.clearContent();
    }
  });

  editorPanel.on('contentChanged', function(editor) {
    var currentTab = tabPanel.getActiveTab();
    var fileName = currentTab.id;
    var content = editor.getContent();

    var data = {
      node: fileName,
      content: content
    };

    $.ajax({
      type: 'POST',
      url: '/node/update',
      dataType: 'json',
      data: data,
      success: function(data) {
        tabPanel.updateOrCreateTab(fileName, data);
      }
    });
  });

  treePanel.on('click', function(node, e) {
    if (node.isLeaf()) {
      var fileName = node.id;
      var name = node.text;
      
      tabPanel.updateOrCreateTab(fileName, name);
    }
  });

  treePanel.on('movenode', function(tree, node, oldParent, newParent, position) {
    var fileName = node.id;
    var destDir = newParent.id;
    
    var data = {
      fileName: fileName,
      destDir: destDir
    };

    $.ajax({
      type: 'POST',
      url: '/node/move',
      dataType: 'json',
      data: data,
      success: function(data) {
        console.log(data);
      }
    });
  });

  // Create main layout

  var sidePanel = new Ext.Panel({
    region: 'west',
    id: 'west-panel',
    title: 'Pages',
    split: true,
    width: 260,
    minSize: 260,
    maxSize: 500,
    collapsible: true,
    margins: '0 0 5 5',
    cmargins: '0 0 0 0',
    items: [treePanel]
  });

  var mainPanel = new Ext.Container({
    region: 'center',
    layout: 'border',
    items: [tabPanel, editorPanel]
  });

  new Ext.Viewport({
    layout: 'border',
    items: [sidePanel, mainPanel]
  });

});
