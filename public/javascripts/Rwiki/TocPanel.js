Ext.ns('Rwiki');

Rwiki.TocPanel = Ext.extend(Ext.Panel, {
  constructor: function() {
    this._current_page_path = null;
    this._default_content = 'When you select a page from the tree, the Table of Content will display here.';
    this._page_without_toc_content = 'This page does not have any sections.';

    Ext.apply(this, {
      id: 'toc-panel',
      title: 'Table of Content',
      region: 'south',
      split: true,
      height: 300,
      bodyStyle: 'padding-bottom:15px;background:#eee;',
      autoScroll: true,
      html: '<div id="toc-container"></div>'
    });

    Rwiki.TocPanel.superclass.constructor.apply(this, arguments);

    this.relayEvents(Rwiki.tabPanel, ['tabchange'])
    this.relayEvents(Rwiki.Data.PageManager.getInstance(), ['rwiki:pageSaved']);

    this.on('tabchange', function(panel, tab) {
      if (tab) {
        var page = tab.getPage();
        this._setContent(page.getHtmlToc());
      } else {
        // the last tab was closed
        this._setContent(this._default_content);
      }
    });

    this.on('rwiki:pageSaved', function(page) {
      this._setContent(page.getHtmlToc());
    });
  },

  render: function() {
    Rwiki.TocPanel.superclass.render.apply(this, arguments);
    this._setContent(this._default_content);
  },

  _setContent: function(content) {
    var container = Ext.get('toc-container');

    if (content != '') {
      container.update(content);
    } else {
      container.update(this._page_without_toc_content);
    }
  }
});

