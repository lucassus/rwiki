Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Node = Ext.extend(Ext.tree.AsyncTreeNode, {
  getPath: function() {
    var path = Rwiki.TreePanel.Node.superclass.getPath.call(this, 'baseName');

    // Remove fist '/' from path.
    return path.replace(/^\//, '');
  },

  getBaseName: function() {
    return this.attributes.baseName;
  }
});
