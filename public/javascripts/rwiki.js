Ext.ns('Rwiki');

Rwiki.rootFolderName = '.';

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
    var pageName = this.id;
    var tab = tabPanel.findTabByPageName(pageName);
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
  model.on(model.NODE_LOADED, function(pageName, data) {
    var node = treePanel.findNodeByPageName(pageName);
    node.select();
    
    editorPanel.getEditor().setContent(data.raw);
    tabPanel.updateOrCreateTab(pageName, data.html);
  });

  // Event: folder has been created
  model.on(model.FOLDER_CREATED, function(parentFolderName, newFolderName) {
    var parentNode = treePanel.findNodeByPageName(parentFolderName);
    parentNode.reload();
  });

  // Event: page has been created
  model.on(model.PAGE_CREATED, function(parentFolderName, newPageName) {
    var parentNode = treePanel.findNodeByPageName(parentFolderName);

    parentNode.reload(function() {
      // slect a new node and open a new page
      var node = treePanel.findNodeByPageName(newPageName, parentNode);
      node.select();
      tabPanel.updateOrCreateTab(newPageName);
    });
  });

  // Event: node has been moved
  model.on(model.NODE_MOVED, function(oldNodeName, destFolderName) {
    var node = treePanel.findNodeByPageName(oldNodeName);
    var destNode = treePanel.findNodeByPageName(destFolderName);

    Rwiki.closeAllRelatedTabs(node, tabPanel);
    destNode.reload();
  });

  // Event: node has been renamed
  model.on(model.NODE_RENAMED, function(data) {
    if (data.success) {
      var node = treePanel.findNodeByPageName(data.oldNodeName);
      if (node == null) return;

      Rwiki.closeAllRelatedTabs(node, tabPanel);
      node.parentNode.reload();
    } else {
      Ext.MessageBox.alert("Error!", "Can't rename node.");
    }
  });

  // Event: node has been deleted
  model.on(model.NODE_DELETED, function(nodeName) {
    var node = treePanel.findNodeByPageName(nodeName);
    
    Rwiki.closeAllRelatedTabs(node, tabPanel);
    node.remove();
  });

  // Event: tab has changed
  tabPanel.on('tabchange', function(tabPanel, tab) {
    var lastTabClosed = !tab;
    
    if (!lastTabClosed) {
      var pageName = tab.id;
      model.loadNode(pageName);
    } else {
      editorPanel.editor.clearContent();
    }
  });

  // Event: editor content changed
  editorPanel.on('contentChanged', function(editor) {
    var currentTab = tabPanel.getActiveTab();
    var pageName = currentTab.id;
    var content = editor.getContent();

    var data = {
      pageName: pageName,
      content: content
    };

    $.ajax({
      type: 'POST',
      url: '/node/update',
      dataType: 'json',
      data: data,
      success: function(data) {
        tabPanel.updateOrCreateTab(pageName, data.html);
      }
    });
  });

  // TreePanel events

  // Event: click on a node
  treePanel.on('click', function(node, e) {
    if (node.isLeaf()) {
      var pageName = node.id;
      tabPanel.updateOrCreateTab(pageName);
    }
  });

  // Event: a node has been moved
  treePanel.on('movenode', function(tree, node, oldParent, newParent, position) {
    var nodeName = node.id;
    var destFolderName = newParent.id;
    
    model.moveNode(nodeName, destFolderName);
  });

  // Attach listeners to the tree context menu

  var treeContextMenu = treePanel.getContextMenu();

  // Event: context menu, create folder
  treeContextMenu.on('createFolder', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, folderBaseName) {
      if (button != 'ok') return;

      var parentFolderName = node.id;
      model.createNode(parentFolderName, folderBaseName, true);
    };

    Ext.MessageBox.prompt('Create folder', 'New folder name:', callback);
  });

  // Event: context menu, create page
  treeContextMenu.on('createPage', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, fileBaseName) {
      if (button != 'ok') return;

      var parentFolderName = node.id;
      model.createNode(parentFolderName, fileBaseName, false);
    };

    Ext.MessageBox.prompt('Create page', 'New page name:', callback);
  });

  // Event: context menu, rename node
  treeContextMenu.on('renameNode', function(node) {
    var oldNodeName = node.id;
    var oldBaseName = node.text;

    var callback = function(button, newBaseName) {
      if (button != 'ok') return;
      model.renameNode(oldNodeName, newBaseName);
    }

    Ext.MessageBox.prompt('Rename node', 'Enter a new name:', callback, this, false, oldBaseName);
  });

  // Event context menu, delete node
  treeContextMenu.on('deleteNode', function(node) {
    var nodeName = node.id;

    var callback = function(button) {
      if (button != 'yes') return;
      model.deleteNode(nodeName);
    }

    var message = 'Delete "' + nodeName + '"?';
    Ext.MessageBox.confirm('Confirm', message, callback);
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
