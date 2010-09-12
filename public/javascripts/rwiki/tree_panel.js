Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {
    var toolBar = new Ext.Toolbar({
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
          }
        },
        scope: this
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
    });

    config = Ext.apply({
      id: 'tree',
      rootVisible: true,
      useArrows: true,
      autoScroll: true,
      animate: true,
      containerScroll: false,
      border: false,
      loader: new Rwiki.TreePanel.Loader(),

      enableDD: true,
      dropConfig: {
        appendOnly: true
      },

      tbar: toolBar
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);

    // setup root node
    var root = {
      nodeType: 'async',
      text: 'Home',
      draggable: false,
      id: Rwiki.rootDirName
    };
    this.setRootNode(root);

    // install event handlers
    this.on('contextmenu', this.onContextMenu, this);

    this.root.expand();
  },

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
    }

    return this.contextMenu;
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

  findNodeByFileName: function(fileName, startNode) {
    var foundNode = null;

    var node = startNode ? startNode : this.root;
    node.cascade(function() {
      if (this.id == fileName) {
        foundNode = this;
        return;
      }
    });

    return foundNode;
  }
});
