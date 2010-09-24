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

  // Attach listeners to the tree context menu
  var treeContextMenu = treePanel.getContextMenu();

  // Event: context menu, create folder
  treeContextMenu.on('createFolder', function(node) {
    if (node.cls == 'file') return;

    Ext.MessageBox.prompt('Create folder', 'New folder name:', function(button, name) {
      if (button != 'ok') return;

      var parentPath = node.id;

      $.ajax({
        type: 'POST',
        url: '/node',
        dataType: 'json',
        data: {
          parentPath: parentPath,
          name: name,
          isFolder: true
        },
        success: function(data) {
          if (!data.success) return;

          var parentPath = data.parentPath;
          var path = data.path;
          var text = data.text;

          var node = new Ext.tree.TreeNode({
            id: path,
            text: text,
            cls: 'folder',
            expandable: true,
            leaf: false
          });

          var parentNode = treePanel.findNodeByPagePath(parentPath);
          parentNode.appendChild(node);
        }
      });
    });
  });

  // Event: context menu, create page
  treeContextMenu.on('createPage', function(node) {
    if (node.cls == 'file') return;

    Ext.MessageBox.prompt('Create page', 'New page name:', function(button, name) {
      if (button != 'ok') return;

      var parentPath = node.id;

      $.ajax({
        type: 'POST',
        url: '/node',
        dataType: 'json',
        data: {
          parentPath: parentPath,
          name: name,
          isFolder: false
        },
        success: function(data) {
          if (!data.success) return;

          var text = data.text;
          var parentPath = data.parentPath;
          var path = data.path;

          var node = new Ext.tree.TreeNode({
            id: path,
            text: text,
            cls: 'page',
            expandable: false,
            leaf: true
          });

          var parentNode = treePanel.findNodeByPagePath(parentPath);
          parentNode.appendChild(node);
          node.select();

          // open tab with new page
          var tab = tabPanel.updateOrAddPageTab(path);
          tab.show();
        }
      });
    });
  });

  // Event: context menu, rename node
  //  treeContextMenu.on('renameNode', function(node) {
  //    var oldPath = node.id;
  //    var oldName = node.text;
  //
  //    var callback = function(button, newName) {
  //      if (button != 'ok') return;
  //    };
  //
  //    Ext.MessageBox.prompt('Rename node', 'Enter a new name:', callback, this, false, oldName);
  //  });

  // Event context menu, delete node
  treeContextMenu.on('deleteNode', function(node) {
    var path = node.id;
  
    var callback = function(button) {
      if (button != 'yes') return;


      $.ajax({
        type: 'DELETE',
        url: '/node?path=' + path,
        dataType: 'json',
        success: function(data) {
          if (!data.success) return;

          var path = data.path;
          var node = treePanel.findNodeByPagePath(path);

          tabPanel.closeRelatedTabs(node);
          node.remove();
        }
      });
    }

    var message = 'Delete "' + path + '"?';
    Ext.MessageBox.confirm('Confirm', message, callback);
  });

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
