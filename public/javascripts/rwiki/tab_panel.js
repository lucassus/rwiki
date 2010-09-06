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

  addTab: function(id) {
    var currentTab = this.getTabById(id);

    if (!currentTab) {
      var pagePanel = new Ext.Container({
        closable: true,
        id: id,
        title: id.replace(/-/g, '/'),
        iconCls: 'tabs'
      });

      this.add(pagePanel).show();
    } else {
      currentTab.show();
    }
  },

  setEditor: function(editor) {
    this.editor = editor;
  },

  loadPageContent: function(id) {
    var self = this;
    
    $.ajax({
      type: 'GET',
      url: '/node/content',
      dataType: 'json',
      data: {
        node: id
      },
      success: function(data) {
        self.editor.setContent(data.raw);
        $('#' + id).html(data.html);
      }
    });
  },

  getTabById: function(id) {
    return this.find('id', id)[0];
  }
});
