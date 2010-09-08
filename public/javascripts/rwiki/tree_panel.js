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

    this.getRootNode().expand();
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
