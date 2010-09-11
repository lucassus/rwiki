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
 */
Rwiki.closeAllTabs = function(node, tabPanel) {
  node.cascade(function() {
    var fileName = this.id;
    var tab = tabPanel.getTabByFileName(fileName);
    if (tab) {
      tabPanel.remove(tab);
    }
  });
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

Rwiki.createNode = function(node, name, isDirectory) {
  if (name == null || name == '') return;

  var parentDirectoryName = node.id;

  $.ajax({
    type: 'POST',
    url: '/node/create',
    dataType: 'json',
    data: {
      parentDirectoryName: parentDirectoryName,
      name: name,
      directory: isDirectory
    },
    success: function(data) {
      node.reload();
    }
  });
};

Rwiki.createDirectory = function(node) {
  if (node.cls == 'file') return;

  var callback = function(button, name) {
    if (button != 'ok') return;
    Rwiki.createNode(node, name, true);
  };

  Ext.Msg.prompt('Create directory', 'New directory name:', callback);
};

Rwiki.createPage = function(node) {
  if (node.cls == 'file') return;

  var callback = function(button, name) {
    if (button != 'ok') return;
    Rwiki.createNode(node, name, false);
  };

  Ext.Msg.prompt('Create page', 'New page name:', callback);
};

Rwiki.moveNode = function(node, newParent, tabPanel) {
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
      Rwiki.closeAllTabs(node, tabPanel);
      newParent.reload();
    }
  });
};

Rwiki.deleteNode = function(node, tabPanel) {
  var fileName = node.id;

  var callback = function(button) {
    if (button != 'yes') return;

    $.ajax({
      type: 'POST',
      url: '/node/destroy',
      dataType: 'json',
      data: {
        fileName: fileName
      },
      success: function(data) {
        Rwiki.closeAllTabs(node, tabPanel);
        node.remove();
      }
    });
  }

  var message = 'Delete "' + fileName + '"?';
  Ext.Msg.confirm('Confirm', message, callback);
};

Rwiki.renameNode = function(node, tabPanel) {
  var oldFileName = node.id;
  var oldName = node.text;

  var callback = function(button, newFileName) {
    if (button != 'ok') return;
    
    $.ajax({
      type: 'POST',
      url: '/node/rename',
      dataType: 'json',
      data: {
        oldName: oldFileName,
        newName: newFileName
      },
      success: function(data) {
        Rwiki.closeAllTabs(node, tabPanel);
        node.parentNode.reload();
      }
    });
  }

  Ext.Msg.prompt('Rename node', 'Enter a new name:', callback, this, false, oldName);
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
      fileName: fileName,
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

  // TreePanel events

  treePanel.on('click', function(node, e) {
    if (node.isLeaf()) {
      var fileName = node.id;
      var name = node.text;
      
      tabPanel.updateOrCreateTab(fileName, name);
    }
  });

  treePanel.on('movenode', function(tree, node, oldParent, newParent, position) {
    Rwiki.moveNode(node, newParent, tabPanel);
  });

  // Attach listeners to the tree context menu

  var treeContextMenu = treePanel.getContextMenu();

  treeContextMenu.on('createDirectory', function(node) {
    Rwiki.createDirectory(node);
  });

  treeContextMenu.on('createPage', function(node) {
    Rwiki.createPage(node);
  });

  treeContextMenu.on('renameNode', function(node) {
    Rwiki.renameNode(node, tabPanel);
  });

  treeContextMenu.on('deleteNode', function(node) {
    Rwiki.deleteNode(node, tabPanel);
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
