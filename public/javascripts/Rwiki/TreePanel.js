Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {
    var self = this;

    // setup TreeFilter
    this.hiddenPkgs = [];
    this.filter = new Ext.tree.TreeFilter(self, {
      clearBlank: true,
      autoClear: true
    });

    var toolBar = new Rwiki.TreePanel.Toolbar();

    var defaultConfig = {
      id: 'tree',
      rootVisible: true,
      useArrows: true,
      animate: true,
      border: false,
      loader: new Rwiki.TreePanel.Loader(),

      enableDD: true,
      dropConfig: {
        appendOnly: true
      },

      tbar: toolBar,
      listeners: {
        click: function(node) {
          if (!node.isLeaf()) return;
          
          var path = node.id;
          this.fireEvent('pageChanged', path);
        }
      }
    };

    Rwiki.TreePanel.superclass.constructor.call(this, Ext.apply(defaultConfig, config));
    this.addEvents('pageChanged');

    // setup root node
    var root = {
      nodeType: 'async',
      text: 'Home',
      draggable: false,
      id: Rwiki.rootFolderName
    };
    this.setRootNode(root);
    new Ext.tree.TreeSorter(this, {
      folderSort: false
    });

    // install event handlers
    this.on('contextmenu', this.onContextMenu, this);

    // toolbar events
    toolBar.on('expandAll', function() {
      self.root.expandChildNodes(true);
    });
    toolBar.on('collapseAll', function() {
      self.root.collapseChildNodes(true);
    });
    toolBar.on('filterFieldChanged', this.filterTree, this);

    // context menu events
    this.contextMenu = new Rwiki.TreePanel.Menu();

    this.contextMenu.on('createFolder', function(node) {
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
    this.contextMenu.on('createPage', function(node) {
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
    //  this.contextMenu.on('renameNode', function(node) {
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
    this.contextMenu.on('deleteNode', function(node) {
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

    this.root.expand();
  },

  filterTree: function(text) {
    var self = this;
    
    Ext.each(this.hiddenPkgs, function(node) {
      node.ui.show();
    });

    if (!text) {
      this.filter.clear();
      return;
    }
    this.expandAll();

    this.markCount  = [];
    this.hiddenPkgs = [];

    if (text.trim().length > 0) {
      this.expandAll();

      var re = new RegExp( Ext.escapeRe(text), 'i');
      this.root.cascade(function(n) {
        if (re.test(n.text))
          self.markToRoot(n, self.root);
      });

      // hide empty packages that weren't filtered
      this.root.cascade(function(n){
        if ((!self.markCount[n.id] || self.markCount[n.id] == 0 ) && n != self.root) {
          n.ui.hide();
          self.hiddenPkgs.push(n);
        }
      });
    }
  },

  markToRoot: function( n, root ){
    if (this.markCount[n.id])
      return;

    this.markCount[n.id] = 1;

    if (n.parentNode != null)
      this.markToRoot(n.parentNode, root);
  },

  onContextMenu : function(node, e) {
    this.showContextMenu(node, e);
  },

  showContextMenu: function(node, e) {
    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
    }

    this.contextMenu.show(node, e.getXY());
  },

  setTabPanel: function(tabPanel) {
    this.tabPanel = tabPanel;
  },

  getSelectedNode: function() {
    return this.getSelectionModel().getSelectedNode();
  },

  findNodeByPagePath: function(path, startNode) {
    var foundNode = null;

    var node = startNode ? startNode : this.root;
    node.cascade(function() {
      if (this.id == path) {
        foundNode = this;
        return;
      }
    });

    return foundNode;
  }
});
