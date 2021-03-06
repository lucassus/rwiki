Ext.ns('Rwiki.Tree');

Rwiki.Tree.Loader = Ext.extend(Ext.tree.TreeLoader, {
  constructor: function() {
    Ext.apply(this, {
      preloadChildren: true,
      clearOnLoad: false
    });

    Rwiki.Tree.Loader.superclass.constructor.apply(this, arguments);

    // pass extra parameters
    this.on('beforeload', function(loader, node) {
      loader.baseParams = {
        path: node.getPath()
      };
    });
  },

  createNode: function(attr) {
    return new Rwiki.Tree.Node(attr);
  }
});
