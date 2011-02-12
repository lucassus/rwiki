Ext.ns('Rwiki.Tree');

Rwiki.Tree.Node = Ext.extend(Ext.tree.AsyncTreeNode, {
  getPath: function() {
    return Rwiki.Tree.Node.superclass.getPath.call(this, 'text');
  },

  expandAll: function() {
    var nodes = [];

    this.bubble(function(n) {
      nodes.push(n);
    });

    nodes = nodes.reverse();

    for (var i = 0, len = nodes.length; i < len; i++) {
      var node = nodes[i];
      if (node.isExpandable()) {
        node.expand(false);
      }
    }
  },

  /**
   * Better version of cascade function.
   * It can iterate through collapsed nodes.
   * @see cascade
   */
  cascadeAll: function(fn, scope, args) {
    var wasCollapsed = this.isExpandable() && !this.isExpanded();

    if (wasCollapsed) {
      this.expand(false, false);
    }

    if (fn.apply(scope || this, args || [this]) !== false){
      var cs = this.childNodes;
      for (var i = 0, len = cs.length; i < len; i++) {
        cs[i].cascadeAll(fn, args);
      }
    }

    if (wasCollapsed) {
      this.collapse(false, false);
    }
  }

});
