Ext.ns('Rwiki.TreePanel');

Rwiki.TreePanel.Node = Ext.extend(Ext.tree.AsyncTreeNode, {
  getPath: function() {
    var path = Rwiki.TreePanel.Node.superclass.getPath.call(this, 'baseName');

    // remove fist '/' from the path
    return path.replace(/^\//, '');
  },

  setBaseName: function(baseName) {
    this.attributes.baseName = baseName;
    this.setTitle(baseName.replace(new RegExp('\.txt$'), ''));
  },

  getBaseName: function() {
    return this.attributes.baseName;
  }
});
