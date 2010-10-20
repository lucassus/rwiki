Ext.ns('Rwiki');

Rwiki.Exttensions = (function() {

  var originalGetPath = Ext.tree.TreeNode.prototype.getPath;
  Ext.override(Ext.tree.TreeNode, {
    getPath: function() {
      var path = originalGetPath.call(this, 'baseName');

      // Remove fist '/' from path.
      return path.replace(/^\//, '');
    }
  });

}());
