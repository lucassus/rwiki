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
        id: 'src'
      },

      listeners: {
        click: function(node, event) {
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
    this.tabPanel = config.tabPanel;

    this.getRootNode().expand();
  },

  loadContent: function(node) {
    var self = this;

    $.ajax({
      type: 'POST',
      url: '/node/content',
      dataType: 'json',
      data: {
        node: node.id
      },
      success: function(data) {
        $('#editor').val(data.raw);
        self.tabPanel.addFileTab(node.id, data.html);
      }
    });
  }
});
