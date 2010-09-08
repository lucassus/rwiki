Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {
    config = Ext.apply({
      useArrows: true,
      autoScroll: true,
      animate: true,
      containerScroll: true,
      border: false,
      dataUrl: '/nodes',

      root: {
        nodeType: 'async',
        text: 'Home',
        draggable: false,
        id: 'src-dir'
      },

      listeners: {
        click: function(node) {
          if (node.leaf) {
            this.loadContent(node);
          } else {
            if (node.isExpanded()) {
              node.collapse();
            } else {
              node.expand();
            }
          }
        }
      }
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);
    this.on('contextmenu', this.onContextClick, this);

    this.getRootNode().expand();
  },

  onContextClick : function(node, e) {
    // create context menu on first right click
    this._buildMenu();

    this.menu.showAt(e.getXY());
    e.stopEvent();
  },

  _buildMenu: function() {
    if (!this.menu) {
      this.menu = new Ext.menu.Menu({
        id:'tree-ctx',
        items: [{
          text: 'New folder',
          iconCls: 'new-folder',
          scope: this,
          handler: function() {}
        }, {
          text: 'New page',
          iconCls: 'new-page',
          scope: this,
          handler: function() {}
        }]
      });
    }

    return this.menu;
  },

  setTabPanel: function(tabPanel) {
    this.tabPanel = tabPanel;
  },

  loadContent: function(node) {
    if (this.tabPanel) {
      this.tabPanel.addTab(node.id);
    }
  },

  getSelectedNode: function() {
    return this.getSelectionModel().getSelectedNode();
  }
});
