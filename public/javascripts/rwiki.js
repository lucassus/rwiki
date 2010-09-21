Ext.ns('Rwiki');

Rwiki.rootFolderName = '.';
Rwiki.currentPageName = null;

Ext.onReady(function() {
  Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

  var model = new Rwiki.Model();

  var treePanel = new Rwiki.TreePanel();
  var tabPanel = new Rwiki.TabPanel();
  var editorPanel = new Rwiki.EditorPanel();

  // TODO: 1/ insert a new node, 2/ sort nodes by name, 3/ if page open it in new tab

  // Event: node has been renamed
//  model.on(model.NODE_RENAMED, function(data) {
//    if (data.success) {
//      var node = treePanel.findNodeByPageName(data.oldNodeName);
//      if (node == null) return;
//
//      tabPanel.closeRelatedTabs(node);
//      node.parentNode.reload();
//    } else {
//      Ext.MessageBox.alert("Error!", "Can't rename node.");
//    }
//  });

  // Event: node has been moved
//  model.on(model.NODE_MOVED, function(oldNodeName, destFolderName) {
//    var node = treePanel.findNodeByPageName(oldNodeName);
//    var destNode = treePanel.findNodeByPageName(destFolderName);
//
//    tabPanel.closeRelatedTabs(node);
//    destNode.reload();
//  });

  // Event: editor content changed
  editorPanel.on('contentChanged', function(content) {
    var currentTab = tabPanel.getActiveTab();
    var pageName = currentTab.getPagePath();

    model.updatePage(pageName, content, function(data) {
      var path = data.path;
      var tab = tabPanel.findTabByPagePath(path);
      tab.setContent(data.html);
    });
  });

  // Event: tab has changed
  tabPanel.on('tabchange', function(tabPanel, tab) {
    var lastTabClosed = !tab;

    if (!lastTabClosed) {
      var pageName = tab.getPagePath();
      
      model.loadPage(pageName, function(data) {
        if (!data.success) return;

        var path = data.path;
        var raw = data.raw;

        // select loaded node in tree
        var node = treePanel.findNodeByPagePath(path);
        node.select();

        // show tab with page
        var tab = tabPanel.updateOrAddPageTab(path, data.html);
        tab.setTitle(data.title);
        tab.show();

        // set editor content
        editorPanel.getEditor().setContent(raw);
      });
    } else {
      editorPanel.editor.clearContent();
    }
  });

  // Event: TreePanel, click on a node
  treePanel.on('click', function(node, e) {
    if (node.isLeaf()) {
      var path = node.id;
      var tab = tabPanel.updateOrAddPageTab(path);
      tab.show(); // it will fire the 'tabchange' event
    }
  });

  // Event: TreePanel, a node has been moved
  treePanel.on('movenode', function(tree, node, oldParent, newParent, position) {
    var path = node.id;
    var destPath = newParent.id;
    
    model.moveNode(path, destPath);
  });

  // Attach listeners to the tree context menu
  var treeContextMenu = treePanel.getContextMenu();

  // Event: context menu, create folder
  treeContextMenu.on('createFolder', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, folderBaseName) {
      if (button != 'ok') return;

      var parentPath = node.id;
      model.createNode(parentPath, folderBaseName, true, function(data) {
        if (!data.success) return;

        var parentPath = data.parentPath;
        var path = data.path;
        var title = data.title;

        var parentNode = treePanel.findNodeByPagePath(parentPath);

        var node = new Ext.tree.TreeNode({
          id: path,
          text: title,
          cls: 'folder',
          expandable: true,
          leaf: false
        });

        parentNode.appendChild(node);
      });
    };

    Ext.MessageBox.prompt('Create folder', 'New folder name:', callback);
  });

  // Event: context menu, create page
  treeContextMenu.on('createPage', function(node) {
    if (node.cls == 'file') return;

    var callback = function(button, name) {
      if (button != 'ok') return;

      var parentPath = node.id;
      model.createNode(parentPath, name, false, function(data) {
        if (!data.success) return;

        var text = data.text;
        var parentFolderName = data.parentFolderName;
        var newPageName = data.newNodeName;

        var parentNode = treePanel.findNodeByPagePath(parentFolderName);

        var node = new Ext.tree.TreeNode({
          id: newPageName,
          text: text,
          cls: 'page',
          expandable: false,
          leaf: true
        });

        parentNode.appendChild(node);
        node.select();

        // open tab with new page
        var tab = tabPanel.updateOrAddPageTab(newPageName);
        tab.show();
      });
    };

    Ext.MessageBox.prompt('Create page', 'New page name:', callback);
  });

  // Event: context menu, rename node
  treeContextMenu.on('renameNode', function(node) {
    var oldPath = node.id;
    var oldName = node.text;

    var callback = function(button, newName) {
      if (button != 'ok') return;

      model.renameNode(oldPath, newName, function(data) {

      });
    };

    Ext.MessageBox.prompt('Rename node', 'Enter a new name:', callback, this, false, oldName);
  });

  // Event context menu, delete node
  treeContextMenu.on('deleteNode', function(node) {
    var nodeName = node.id;

    var callback = function(button) {
      if (button != 'yes') return;
      model.deleteNode(nodeName, function(data) {
        if (!data.success) return;
        
        var nodeName = data.nodeName;
        var node = treePanel.findNodeByPagePath(nodeName);

        tabPanel.closeRelatedTabs(node);
        node.remove();
      });
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
    width: 265,
    minSize: 265,
    maxSize: 500,
    collapsible: true,
    autoScroll: true,
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
