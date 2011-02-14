Ext.ns('Rwiki');

Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function() {

    Ext.apply(this, {
      id: 'tree',
      region: 'center',
      autoScroll: true,

      animate: true,
      useArrows: true,
      rootVisible: true,
      loader: new Rwiki.Tree.Loader(),

      enableDD: true,
      dropConfig: {
        appendOnly: true
      },

      root: new Rwiki.Tree.Node({
        nodeType: 'async',
        text: Rwiki.rootFolderName,
        draggable: false
      })
    });

    Rwiki.TreePanel.superclass.constructor.apply(this, arguments);
    this.root.expand();

    new Ext.tree.TreeSorter(this, {
      folderSort: true
    });

    this.contextMenu = new Rwiki.Tree.Menu();
    this.on('contextmenu', this.onContextMenu, this);

    this.addEvents('rwiki:pageSelected');
  },

  initEvents: function() {
    Rwiki.TreePanel.superclass.initEvents.apply(this, arguments);

    this.on('click', this.onClick);

    this.on('rwiki:pageLoaded', this.onPageLoaded);
    this.on('rwiki:pageCreated', this.onPageCreated);
    this.on('rwiki:nodeRenamed', this.onNodeRenamed);
    this.on('rwiki:nodeDeleted', this.onNodeDeleted);
    this.on('beforemovenode', this.onBeforeMoveNode);

    this.relayEvents(Rwiki.Data.NodeManager.getInstance(), [
      'rwiki:pageLoaded',
      'rwiki:pageCreated',
      'rwiki:nodeRenamed',
      'rwiki:nodeDeleted']);
  },

  onContextMenu: function(node, e) {
    if (!this.contextMenu) return;

    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
    }

    this.contextMenu.show(node, e.getXY());
  },

  onClick: function(node) {
    var page = new Rwiki.Data.Node({ path: node.getPath() });
    this.fireEvent('rwiki:pageSelected', page);
  },

  onPageLoaded: function(page) {
    var node = this.findNodeByPath(page.getPath());
    if (node) {
      node.select();
    }
  },

  onPageCreated: function(page) {
    var treeNode = new Rwiki.Tree.Node({
      baseName: page.getBaseName(),
      text: page.getTitle(),
      expandable: false,
      leaf: true
    });

    var parentNode = this.findNodeByPath(page.getParentPath());
    parentNode.expand();
    parentNode.appendChild(treeNode);
    treeNode.select();
  },

  onNodeRenamed: function(page) {
    var treeNode = this.findNodeByPath(page.getData().oldPath);
    treeNode.setBaseName(page.getBaseName());
    treeNode.setText(page.getTitle());
  },

  onNodeDeleted: function(data) {
    var path = data.path;
    var node = this.findNodeByPath(path);
    node.remove();
  },

  onBeforeMoveNode: function(tree, node, oldParent, newParent, index) {
    var path = node.getPath();
    var newParentPath = newParent.getPath();

    var result = Rwiki.Data.NodeManager.getInstance().moveNode(path, newParentPath);

    return result.success;
  },

  findNodeByPath: function(path) {
    var node = null;
    this.root.cascadeAll(function(curretNode) {
      if (curretNode.getPath() == path) {
        node = curretNode;
        return false;
      }
    });

    return node;
  },

  openNodeFromLocationHash: function() {
    if (!location.hash) return;

    var path = location.hash.replace(new RegExp('^#'), '');
    var node = this.findNodeByPath(path);
    if (node) {
      node.expandAllParents();
      this.onClick(node);
    }
  }
});
