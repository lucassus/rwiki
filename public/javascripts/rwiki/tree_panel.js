Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {

    config = Ext.apply({
      id: 'tree',
      rootVisible: true,
      useArrows: true,
      autoScroll: true,
      animate: true,
      containerScroll: false,
      border: false,
      dataUrl: '/nodes',

      tbar: this.toolBar,

      root: {
        nodeType: 'async',
        text: 'Home',
        draggable: false,
        id: Rwiki.rootNodeId
      }
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);

    // install event handlers
    this.on('contextmenu', this.onContextMenu, this);

    this.root.expand();
  },

  toolBar: new Ext.Toolbar({
    items: [
      new Ext.form.TextField({
        width: 200,
        emptyText: 'Find a Page',
        enableKeyEvents: true,
        listeners: {
          render: function(f) {
            this.filter = new Ext.tree.TreeFilter(this, {
              clearBlank: true,
              autoClear: true
            });
          },
          keydown: {
            fn: this.filterTree,
            buffer: 350,
            scope: this
          },
          scope: this
        }
      }), {
        iconCls: 'icon-expand-all',
        tooltip: 'Expand All',
        handler: function() {
          this.root.expand(true);
        },
        scope: this
      }, {
        iconCls: 'icon-collapse-all',
        tooltip: 'Collapse All',
        handler: function() {
          this.root.collapse(true);
          this.root.expand();
        },
        scope: this
      }]
  }),

  filterTree: function(t, e) {
    var text = t.getValue();
    if (!text) {
      this.filter.clear();
      return;
    }

    this.expandAll();

    var re = new RegExp(Ext.escapeRe(text), 'i');
    this.filter.filterBy(function(n) {
      return !n.isLeaf() || re.test(n.text);
    });
  },

  onContextMenu : function(node, e) {
    this.showContextMenu(node, e);
  },

  getContextMenu: function() {
    if (this.contextMenu == null) {
      this.contextMenu = new Rwiki.TreePanel.Menu();
      this.contextMenu.on('click', this.onContextMenuClick, this);
    }

    return this.contextMenu;
  },

  onContextMenuClick: function(menu, item, e) {
    if (item.disabled) return;

    var node = menu.node;
    switch (item.command) {
      case 'create-folder':
        this._createFolder(node);
        break;
      case 'create-page':
        this._createPage(node);
        break;
      case 'rename-node':
        break;
      case 'delete-node':
        this._deleteNode(node);
        break;
    }
  },

  showContextMenu: function(node, e) {
    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
    }

    this.getContextMenu().show(node, e.getXY());
  },

  setTabPanel: function(tabPanel) {
    this.tabPanel = tabPanel;
  },

  getSelectedNode: function() {
    return this.getSelectionModel().getSelectedNode();
  },

  _createNode: function(node, name, isFolder) {
    if (name == null || name == '') return;

    $.ajax({
      type: 'POST',
      url: '/node/create',
      dataType: 'json',
      data: {
        node: node.id,
        name: name,
        directory: isFolder
      },
      success: function(data) {
        node.reload();
      }
    });
  },

  // TODO move this outside
  _createFolder: function(node) {
    if (node.cls == 'file') return;

    var name = prompt('Direcotry name:');
    this._createNode(node, name, true);
  },

  _createPage: function(node) {
    if (node.cls == 'file') return;

    var name = prompt('Page name:');
    this._createNode(node, name, false);
  },

  _deleteNode: function(node) {
    if (confirm('Are you sure?')) {
      $.ajax({
        type: 'POST',
        url: '/node/destroy',
        dataType: 'json',
        data: {
          node: node.id
        },
        success: function(data) {
          node.getParentNode().reload();
          // TODO close tab
        }
      });
    }
  },

  _renameNode: function(node) {
    alert('No implemented!');
  }
});
