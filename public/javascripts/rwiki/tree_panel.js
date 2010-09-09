Rwiki.TreePanel = Ext.extend(Ext.tree.TreePanel, {
  constructor: function(config) {
    
    var toolBar = new Ext.Toolbar({
      items: [
      new Ext.form.TextField({
        width: 200,
        emptyText: 'Find a Page',
        enableKeyEvents: true,
        listeners: {
          render: function(f) {
            this.filter = new Ext.tree.TreeFilter(this, {
              clearBlank: true,
              autoClear: true
            });
          },
          keydown: {
            fn: this.filterTree,
            buffer: 350,
            scope: this
          },
          scope: this
        }
      }), {
        iconCls: 'icon-expand-all',
        tooltip: 'Expand All',
        handler: function() {
          this.root.expand(true);
        },
        scope: this
      }, {
        iconCls: 'icon-collapse-all',
        tooltip: 'Collapse All',
        handler: function(){
          this.root.collapse(true);
          this.root.expand();
        },
        scope: this
      }]
    });

    config = Ext.apply({
      rootVisible: false,
      useArrows: true,
      autoScroll: true,
      animate: true,
      containerScroll: false,
      border: false,
      dataUrl: '/nodes',

      tbar: toolBar,

      root: {
        nodeType: 'async',
        text: 'Home',
        draggable: false,
        id: 'root-dir'
      }
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);

    // install event handlers
    this.on('contextmenu', this.onContextMenu, this);

    this.root.expand();
  },

  filterTree: function(t, e){
    var text = t.getValue();
    if (!text) {
      this.filter.clear();
      return;
    }

    this.expandAll();

    var re = new RegExp(Ext.escapeRe(text), 'i');
    this.filter.filterBy(function(n) {
      return !n.isLeaf() || re.test(n.text);
    });
  },

  onContextMenu : function(node, e) {
    // create context menu on first right click
    if (!this.menu) { 
      this.menu = new Ext.menu.Menu({
        id: 'feeds-ctx',
        items: [{
          text: 'Create folder',
          id: 'create-folder',
          iconCls: 'icon-create-folder',
          scope: this,
          handler: function() {
            this._newFolder(this.ctxNode);
          }
        }, {
          text: 'Create page',
          id: 'create-page',
          iconCls: 'icon-create-page',
          scope: this,
          handler: function() {
            this._newPage(this.ctxNode);
          }
        }, {
          text: 'Delete node',
          id: 'delete-node',
          iconCls: 'icon-delete-node',
          scope: this,
          handler: function() {
            this._deleteNode(this.ctxNode);
          }
        }]
      });
      
      this.menu.on('hide', this.onContextHide, this);
    }
        
    this.ctxNode = node;
    this.menu.showAt(e.getXY());
  },

  onContextHide: function() {
    if (this.ctxNode) {
      this.ctxNode = null;
    }
  },

  setTabPanel: function(tabPanel) {
    this.tabPanel = tabPanel;
  },

  getSelectedNode: function() {
    return this.getSelectionModel().getSelectedNode();
  },

  _newFolder: function(node) {
    if (node.cls == 'file') return false;

    var name = prompt('Direcotry name:');
    if (name != null && name != '') {
      $.ajax({
        type: 'POST',
        url: '/node/create',
        dataType: 'json',
        data: {
          node: node.id,
          name: name,
          directory: true
        },
        success: function(data) {
          node.reload();
        }
      });
    }
  },

  _newPage: function(node) {
    if (node.cls == 'file') return false;

    var name = prompt('Page name:');
    if (name != null && name != '') {
      $.ajax({
        type: 'POST',
        url: '/node/create',
        dataType: 'json',
        data: {
          node: node.id,
          name: name,
          directory: false
        },
        success: function(data) {
          node.reload();
        }
      });
    }
  },

  _deleteNode: function(node) {
    if (confirm('Are you sure?')) {
      $.ajax({
        type: 'POST',
        url: '/node/destroy',
        dataType: 'json',
        data: {
          node: node.id
        },
        success: function(data) {
          node.parentNode.reload();
        // TODO close tab
        }
      });
    }
  }
});
