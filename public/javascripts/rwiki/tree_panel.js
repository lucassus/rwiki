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
          }
        },
        scope: this
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
        handler: function() {
          this.root.collapse(true);
          this.root.expand();
        },
        scope: this
      }]
    });

    config = Ext.apply({
      id: 'tree',
      rootVisible: true,
      useArrows: true,
      autoScroll: true,
      animate: true,
      containerScroll: false,
      border: false,
      loader: new Rwiki.TreePanel.Loader(),

      enableDD: true,
      dropConfig: {
        appendOnly: true
      },

      tbar: toolBar
    }, config);

    Rwiki.TreePanel.superclass.constructor.call(this, config);

    // setup root node
    var root = {
      nodeType: 'async',
      text: 'Home',
      draggable: false,
      id: Rwiki.rootDirName
    };
    this.setRootNode(root);

    // install event handlers
    this.on('contextmenu', this.onContextMenu, this);

    this.root.expand();
  },

  filterTree: function(t, e) {
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
    this.showContextMenu(node, e);
  },

  getContextMenu: function() {
    if (this.contextMenu == null) {
      this.contextMenu = new Rwiki.TreePanel.Menu();
      this.contextMenu.on('click', this.onContextMenuClick, this);
    }

    return this.contextMenu;
  },

  onContextMenuClick: function(menu, item, e) {
    if (item.disabled) return;

    var node = menu.node;
    switch (item.command) {
      case 'create-directory':
        this._createDirectory(node);
        break;
      case 'create-page':
        this._createPage(node);
        break;
      case 'rename-node':
        this._renameNode(node);
        break;
      case 'delete-node':
        this._deleteNode(node);
        break;
    }
  },

  showContextMenu: function(node, e) {
    if (!node) {
      node = this.getSelectionModel().getSelectedNode();
    }

    this.getContextMenu().show(node, e.getXY());
  },

  setTabPanel: function(tabPanel) {
    this.tabPanel = tabPanel;
  },

  getSelectedNode: function() {
    return this.getSelectionModel().getSelectedNode();
  },

  _createNode: function(node, name, isDirectory) {
    if (name == null || name == '') return;

    var parentDirectoryName = node.id;

    $.ajax({
      type: 'POST',
      url: '/node/create',
      dataType: 'json',
      data: {
        parentDirectoryName: parentDirectoryName,
        name: name,
        directory: isDirectory
      },
      success: function(data) {
        node.reload();
      }
    });
  },

  // TODO move this outside
  _createDirectory: function(node) {
    if (node.cls == 'file') return;

    var name = prompt('Direcotry name:');
    this._createNode(node, name, true);
  },

  _createPage: function(node) {
    if (node.cls == 'file') return;

    var name = prompt('Page name:');
    this._createNode(node, name, false);
  },

  _deleteNode: function(node) {
    if (confirm('Are you sure?')) {
      var fileName = node.id;

      $.ajax({
        type: 'POST',
        url: '/node/destroy',
        dataType: 'json',
        data: {
          fileName: fileName
        },
        success: function(data) {
          node.remove();
          // TODO close corresponding tab
        }
      });
    }
  },

  _renameNode: function(node) {
    var oldFileName = node.id;

    var oldName = node.text;
    var newFileName = prompt('New name: ', oldName);
    if (newFileName == null || newFileName == '') return;

    $.ajax({
      type: 'POST',
      url: '/node/rename',
      dataType: 'json',
      data: {
        oldName: oldFileName,
        newName: newFileName
      },
      success: function(data) {
        // TODO set new id
        node.setText(newFileName);
      }
    });
  }
});
