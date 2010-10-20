Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Loader = Ext.extend(Ext.tree.TreeLoader, {
  constructor: function() {
    Ext.apply(this, {
      requestMethod: 'GET',
      dataUrl: '/nodes',
      preloadChildren: true
    });

    Rwiki.TreePanel.Loader.superclass.constructor.apply(this, arguments);

    // pass extra parameters
    this.on('beforeload', function(loader, node) {
      loader.baseParams = {
        path: node.getPath('baseName')
      }
    });
  }
});
