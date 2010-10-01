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

      enableDD: false,
      dropConfig: {
        appendOnly: true
      },

      tbar: toolBar
    };

    Rwiki.TreePanel.superclass.constructor.call(this, Ext.apply(defaultConfig, config));

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

    // toolbar events
    toolBar.on('expandAll', function() {
      self.root.expandChildNodes(true);
    });
    toolBar.on('collapseAll', function() {
      self.root.collapseChildNodes(true);
    });
    toolBar.on('filterFieldChanged', this.filterTree, this);

    this.addEvents('pageSelected');
    this.initEventHandlers();
    this.initContextMenu();
    this.on('contextmenu', this.onContextMenu, this);
    
    this.root.expand();
  },

  initEventHandlers: function() {
    this.on('click', function(node) {
      if (!node.isLeaf()) return;

      var path = node.id;
      this.fireEvent('pageSelected', path);
    });

    this.on('folderCreated', function(data) {
      var parentPath = data.parentPath;
      var path = data.path;
      var name = data.text;

      var node = new Ext.tree.TreeNode({
        id: path,
        text: name,
        cls: 'folder',
        expandable: true,
        leaf: false
      });

      var parentNode = this.findNodeByPagePath(parentPath);
      parentNode.appendChild(node);
    });

    this.on('pageCreated', function(data) {
      var name = data.text;
      var parentPath = data.parentPath;
      var path = data.path;

      var node = new Ext.tree.TreeNode({
        id: path,
        text: name,
        cls: 'page',
        expandable: false,
        leaf: true
      });

      var parentNode = this.findNodeByPagePath(parentPath);
      parentNode.appendChild(node);
      node.select();
    });

    this.on('nodeRenamed', function(data) {
      var path = data.path;
      var oldPath = data.oldPath;

      var node = this.findNodeByPagePath(oldPath);
      node.setId(path);
      node.setText(data.title);

      if (!node.isLeaf()) {
        // update children ids
        node.cascade(function() {
          var newId = this.id.replace(oldPath, path);
          this.setId(newId);
        });
      }
    });

    this.on('nodeDeleted', function(data) {
      var path = data.path;
      var node = this.findNodeByPagePath(path);
      node.remove();
    });
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
    var node = startNode ? startNode : this.root;

    var result = null;
    node.cascade(function() {
      if (this.id == path) {
        result = this;
        return;
      }
    });

    return result;
  },

  initContextMenu: function() {
    this.contextMenu = new Rwiki.TreePanel.Menu();
    this.relayEvents(this.contextMenu, ['createFolder', 'createPage', 'renameNode', 'deleteNode']);

    this.on('createFolder', function(parentNode) {
      if (parentNode.cls == 'file') return;

      Ext.MessageBox.prompt('Create folder', 'New folder name:', function(button, name) {
        if (button != 'ok') return;

        var parentPath = parentNode.id;
        Rwiki.nodeManager.fireEvent('createFolder', parentPath, name);
      });
    });

    // Event: context menu, create page
    this.on('createPage', function(parentNode) {
      if (parentNode.cls == 'file') return;

      Ext.MessageBox.prompt('Create page', 'New page name:', function(button, name) {
        if (button != 'ok') return;

        var parentPath = parentNode.id;
        Rwiki.nodeManager.fireEvent('createPage', parentPath, name);
      });
    });

    this.on('renameNode', function(node) {
      var oldPath = node.id;
      var oldName = node.text;

      var callback = function(button, newName) {
        if (button != 'ok') return;
        Rwiki.nodeManager.fireEvent('renameNode', oldPath, newName);
      };

      Ext.MessageBox.prompt('Rename node', 'Enter a new name:', callback, this, false, oldName);
    });

    this.on('deleteNode', function(node) {
      var path = node.id;

      var callback = function(button) {
        if (button != 'yes') return;
        Rwiki.nodeManager.fireEvent('deleteNode', path);
      }

      var message = 'Delete "' + path + '"?';
      Ext.MessageBox.confirm('Confirm', message, callback);
    });
  }
});
