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

/**
 * Closes all opened tabs related to the node.
 * @todo refactor this method
 */
Rwiki.closeAllRelatedTabs = function(node, tabPanel) {
  node.cascade(function() {
    var fileName = this.id;
    var tab = tabPanel.findTabByFileName(fileName);
    if (tab) {
      tabPanel.remove(tab);
    }
  });
};

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var model = new Rwiki.Model();
  
  var treePanel = new Rwiki.TreePanel();
  var tabPanel = new Rwiki.TabPanel();
  var editorPanel = new Rwiki.EditorPanel();

  // Event: node has been loaded
  model.on(model.NODE_LOADED, function(fileName, data) {
    var node = treePanel.findNodeByFileName(fileName);
    node.select();
    
    editorPanel.getEditor().setContent(data.raw);
    tabPanel.updateOrCreateTab(fileName, data.html);
  });

  // Event: directory has been created
  model.on(model.DIRECTORY_CREATED, function(parentDirectoryName, newDirectoryName) {
    var parentNode = treePanel.findNodeByFileName(parentDirectoryName);
    parentNode.reload();
  });

  // Event: page has been created
  model.on(model.PAGE_CREATED, function(parentDirectoryName, newFileName) {
    var parentNode = treePanel.findNodeByFileName(parentDirectoryName);

    parentNode.reload(function() {
      // slect a new node and open a new page
      var node = treePanel.findNodeByFileName(newFileName, parentNode);
      node.select();
      tabPanel.updateOrCreateTab(newFileName);
    });
  });

  // Event: node has been moved
  model.on(model.NODE_MOVED, function(oldNodeName, destDirName) {
    var node = treePanel.findNodeByFileName(oldNodeName);
    var destNode = treePanel.findNodeByFileName(destDirName);

    Rwiki.closeAllRelatedTabs(node, tabPanel);
    destNode.reload();
  });

  // Event: node has been renamed
  model.on(model.NODE_RENAMED, function(oldFileName, newFileName) {
    var node = treePanel.findNodeByFileName(oldFileName);
    
    Rwiki.closeAllRelatedTabs(node, tabPanel);
    node.parentNode.reload();
  });

  // Event: node has been deleted
  model.on(model.NODE_DELETED, function(nodeName) {
    var node = treePanel.findNodeByFileName(nodeName);
    
    Rwiki.closeAllRelatedTabs(node, tabPanel);
    node.remove();
  });

  // Event: tab has changed
  tabPanel.on('tabchange', function(tabPanel, tab) {
    var lastTabClosed = !tab;
    
    if (!lastTabClosed) {
      var fileName = tab.id;
      model.loadNode(fileName);
    } else {
      editorPanel.editor.clearContent();
    }
  });

  // Event: editor content changed
  editorPanel.on('contentChanged', function(editor) {
    var currentTab = tabPanel.getActiveTab();
    var fileName = currentTab.id;
    var content = editor.getContent();

    var data = {
      fileName: fileName,
      content: content
    };

    $.ajax({
      type: 'POST',
      url: '/node/update',
      dataType: 'json',
      data: data,
      success: function(data) {
        tabPanel.updateOrCreateTab(fileName, data.html);
      }
    });
  });

  // TreePanel events

  // Event: click on a node
  treePanel.on('click', function(node, e) {
    if (node.isLeaf()) {
      var fileName = node.id;
      tabPanel.updateOrCreateTab(fileName);
    }
  });

  // Event: a node has been moved
  treePanel.on('movenode', function(tree, node, oldParent, newParent, position) {
    var nodeName = node.id;
    var destDirName = newParent.id;
    
    model.moveNode(nodeName, destDirName);
  });

  // Attach listeners to the tree context menu

  var treeContextMenu = treePanel.getContextMenu();

  // Event: context menu, create directory
  treeContextMenu.on('createDirectory', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, directoryBaseName) {
      if (button != 'ok') return;

      var parentDirectoryName = node.id;
      model.createNode(parentDirectoryName, directoryBaseName, true);
    };

    Ext.Msg.prompt('Create directory', 'New directory name:', callback);
  });

  // Event: context menu, create page
  treeContextMenu.on('createPage', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, fileBaseName) {
      if (button != 'ok') return;

      var parentDirectoryName = node.id;
      model.createNode(parentDirectoryName, fileBaseName, false);
    };

    Ext.Msg.prompt('Create page', 'New page name:', callback);
  });

  // Event: context menu, rename node
  treeContextMenu.on('renameNode', function(node) {
    var oldNodeName = node.id;
    var oldBaseName = node.text;

    var callback = function(button, newBaseName) {
      if (button != 'ok') return;
      model.renameNode(oldNodeName, newBaseName);
    }

    Ext.Msg.prompt('Rename node', 'Enter a new name:', callback, this, false, oldBaseName);
  });

  // Event context menu, delete node
  treeContextMenu.on('deleteNode', function(node) {
    var nodeName = node.id;

    var callback = function(button) {
      if (button != 'yes') return;
      model.deleteNode(nodeName);
    }

    var message = 'Delete "' + nodeName + '"?';
    Ext.Msg.confirm('Confirm', message, callback);
  });

  // Create layout

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
