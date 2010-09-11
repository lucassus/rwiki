Rwiki.TabPanel = Ext.extend(Ext.TabPanel, {
  constructor: function(config) {
    config = Ext.apply({
      region: 'center',
      deferredRender: false,
      activeTab: 0,
      resizeTabs: true,
      minTabWidth: 200,
      enableTabScroll: true,
      defaults: {
        autoScroll: true
      },
      listeners: {
        tabchange: function(tabPanel, tab) {
          if (tab) {
            this.loadPageContent(tab.id);
          } else {
            this.editor.clearContent();
          }
        }
      },
      plugins: new Ext.ux.TabCloseMenu()
    }, config);

    Rwiki.TabPanel.superclass.constructor.call(this, config);
  },

  updateOrCreateTab: function(nodeId, title) {
    var currentTab = this.getTabById(nodeId);

    if (!currentTab) {
      var pagePanel = new Ext.Container({
        closable: true,
        id: nodeId,
        title: title,
        cls: 'page-container',
        iconCls: 'icon-page'
      });

      this.add(pagePanel).show();
    } else {
      currentTab.show();
    }
  },

  setEditor: function(editor) {
    this.editor = editor;
  },

  loadPageContent: function(fileName) {
    var self = this;
    
    $.ajax({
      type: 'GET',
      url: '/node/content',
      dataType: 'json',
      data: {
        node: fileName
      },
      success: function(data) {
        self.editor.setContent(data.raw);
        
        var nodeId = Rwiki.escapedId(fileName);
        $(nodeId).html(data.html);
      }
    });
  },

  getTabById: function(id) {
    return this.find('id', id)[0];
  }
});
