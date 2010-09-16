Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {
    var self = this;
    this.hiddenPkgs = [];

    config = Ext.apply({
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

      tbar: {
        items: [
        new Ext.form.TextField({
          width: 200,
          emptyText: 'Find a Page',
          enableKeyEvents: true,
          listeners: {
            render: function(f) {
              self.filter = new Ext.tree.TreeFilter(self, {
                clearBlank: true,
                autoClear: true
              });
            },
            keydown: {
              fn: self.filterTree,
              buffer: 350,
              scope: this
            }
          },
          scope: this
        }), {
          iconCls: 'icon-expand-all',
          tooltip: 'Expand All',
          handler: function() {
            this.root.expandChildNodes(true);
          },
          scope: this
        }, {
          iconCls: 'icon-collapse-all',
          tooltip: 'Collapse All',
          handler: function() {
            this.root.collapseChildNodes(true);
          },
          scope: this
        }]
      }
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);

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

    this.root.expand();
  },

  filterTree: function(t, e) {
    var self = this;
    
    var text = t.getValue();
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

  findNodeByPageName: function(pageName, startNode) {
    var foundNode = null;

    var node = startNode ? startNode : this.root;
    node.cascade(function() {
      if (this.id == pageName) {
        foundNode = this;
        return;
      }
    });

    return foundNode;
  }
});
