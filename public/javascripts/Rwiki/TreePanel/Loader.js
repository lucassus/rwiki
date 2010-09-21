Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Loader = Ext.extend(Ext.tree.TreeLoader, {
  constructor: function(config) {
    config = Ext.apply({
      requestMethod: 'GET',
      dataUrl: '/nodes'
    }, config);

    Rwiki.TreePanel.Loader.superclass.constructor.call(this, config);

    // pass extra parameters
    this.on('beforeload', function(loader, node) {
      loader.baseParams = {
        path: node.id
      }
    });
  }

});
