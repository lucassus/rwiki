Ext.ns('Rwiki.Tree');

Rwiki.Tree.Filter = Ext.extend(Ext.tree.TreeFilter, {
  constructor: function() {
    this.hiddenNodes = [];

    Ext.apply(this, {
      clearBlank: true,
      autoClear: true
    });

    Rwiki.Tree.Filter.superclass.constructor.apply(this, arguments);
  },

  filterTree: function(text) {
    var self = this;

    Ext.each(this.hiddenNodes, function(node) {
      node.ui.show();
    });

    if (!text) {
      this.clear();
      return;
    }
    this.tree.expandAll();

    this.markCount  = [];
    this.hiddenNodes = [];

    if (text.trim().length > 0) {
      this.tree.expandAll();

      var re = new RegExp(Ext.escapeRe(text), 'i');
      this.tree.root.cascade(function(node) {
        if (re.test(node.text)) {
          self.markToRoot(node, self.root);

          if (!node.isLeaf()) {
            node.cascade(function(child) {
              self.markToRoot(child, node);
            });
          }
        }
      });

      // hide empty packages that weren't filtered
      this.tree.root.cascade(function(node) {
        if (!self.markCount[node.id] && node != self.root) {
          node.ui.hide();
          self.hiddenNodes.push(node);
        }
      });
    }
  },

  markToRoot: function(node, root) {
    if (this.markCount[node.id]) return;

    this.markCount[node.id] = true;

    if (node.parentNode != null) {
      this.markToRoot(node.parentNode, root);
    }
  }
});
