Ext.ns('Rwiki.Tree');

Rwiki.Tree.Node = Ext.extend(Ext.tree.TreeNode, {

  constructor: function(config) {
    config = Ext.apply({
      cls: 'rwiki-tree-node',
      iconCls: 'icon-page'
    }, config);

    Rwiki.Tree.Node.superclass.constructor.call(this, config);

    this.on('beforemove', function(tree, node, oldParent, newParent) {
      // do not allow to move a node to the same parent
      return oldParent != newParent;
    });
  },

  getPath: function() {
    return Rwiki.Tree.Node.superclass.getPath.call(this, 'text');
  },

  getName: function() {
    return this.text;
  },

  expandAllParents: function() {
    var nodes = [];

    this.bubble(function(n) {
      nodes.push(n);
    });

    nodes = nodes.reverse();

    for (var i = 0, len = nodes.length; i < len; i++) {
      var node = nodes[i];

      var isNotACurrNode = node != this;
      if (isNotACurrNode && node.isExpandable()) {
        node.expand(false);
      }
    }
  },

  expandAll: function() {
    if (this.isExpandable()) {
      this.expand();
      var cs = this.childNodes;
      for (var i = 0, len = cs.length; i < len; i++) {
        cs[i].expandAll();
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
