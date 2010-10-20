Ext.ns('Rwiki');

Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function() {
    var toolbar = new Rwiki.TreePanel.Toolbar();

    Ext.apply(this, {
      id: 'tree',
      rootVisible: true,
      useArrows: true,
      animate: true,
      border: false,
      collapsible: false,
      loader: new Rwiki.TreePanel.Loader(),

      enableDD: true,
      dropConfig: {
        appendOnly: true
      },

      root: new Ext.tree.AsyncTreeNode({
        nodeType: 'async',
        text: Rwiki.rootFolderName,
        draggable: false,
        baseName: '.'
      }),

      tbar: toolbar
    });

    Rwiki.TreePanel.superclass.constructor.apply(this, arguments);

    this.filter = new Rwiki.TreePanel.Filter(this);
    this.root.expand();

    new Ext.tree.TreeSorter(this, {
      folderSort: false
    });

    var self = this;

    toolbar.on('expandAll', function() {
      self.root.expandChildNodes(true);
    });

    toolbar.on('collapseAll', function() {
      self.root.collapseChildNodes(true);
    });

    toolbar.on('filterFieldChanged', function(text) {
      self.filter.filterTree(text);
    });

    this.addEvents('pageSelected');
  },

  initEvents: function() {
    Rwiki.TreePanel.superclass.initEvents.apply(this, arguments);

    this.on('click', this.onClick);

    this.on('rwiki:folderCreated', this.onFolderCreated);
    this.on('rwiki:pageCreated', this.onPageCreated);
    this.on('rwiki:nodeRenamed', this.onNodeRenamed);
    this.on('rwiki:nodeDeleted', this.onNodeDeleted);
    this.on('beforemovenode', this.onBefoneMoveNode);
  },

  setContextMenu: function(contextMenu) {
    this.contextMenu = contextMenu;
    this.on('contextmenu', this.onContextMenu, this);
  },

  onContextMenu: function(node, e) {
    if (!this.contextMenu) return;

    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
    }

    this.contextMenu.show(node, e.getXY());
  },

  onClick: function(node) {
    if (!node.isLeaf()) return;

    var path = node.getPath();
    this.fireEvent('pageSelected', path);
  },

  onFolderCreated: function(data) {
    var node = new Ext.tree.TreeNode({
      baseName: data.baseName,
      text: data.baseName,
      cls: 'folder',
      expandable: true,
      leaf: false
    });

    var parentNode = this.findNodeByPath(data.parentPath);
    parentNode.appendChild(node);
  },

  onPageCreated: function(data) {
    var node = new Ext.tree.TreeNode({
      baseName: data.baseName,
      text: data.baseName.replace(new RegExp('\.txt$'), ''),
      cls: 'page',
      expandable: false,
      leaf: true
    });

    var parentNode = this.findNodeByPath(data.parentPath);
    parentNode.expand();
    parentNode.appendChild(node);
    node.select();
  },

  onNodeRenamed: function(data) {
    var node = this.findNodeByPath(data.oldPath);
    node.attributes.baseName = data.baseName;

    var title = data.baseName.replace(new RegExp('\.txt$'), '');
    node.setText(title);
  },

  onNodeDeleted: function(data) {
    var path = data.path;
    var node = this.findNodeByPath(path);
    node.remove();
  },

  onBefoneMoveNode: function(tree, node, oldParent, newParent, index) {
    var path = node.getPath();
    var newParentPath = newParent.getPath();

    var result = Rwiki.NodeManager.getInstance().moveNode(path, newParentPath);

    return result.success;
  },

  findNodeByPath: function(path) {
    var keys = path.split('/');
    var node = this.root;

    if (node.attributes.baseName != keys[0]) {
      return null;
    }

    for (var i = 1, n = keys.length; i < n; i++) {
      var baseName = keys[i];
      if (baseName == '') continue;
      
      node = node.findChild('baseName', baseName);
    }

    return node;
  }
});
