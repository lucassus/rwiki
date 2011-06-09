Ext.ns('Rwiki.Tabs');

Rwiki.Tabs.PageTab = Ext.extend(Ext.Container, {
  constructor: function() {
    Ext.apply(this, {
      closable: true,
      cls: 'page-container',
      iconCls: 'icon-page'
    });

    Rwiki.Tabs.PageTab.superclass.constructor.apply(this, arguments);
  },

  setPage: function(page) {
    this._page = page;
  },

  getPage: function() {
    return this._page;
  },

  setTitle: function(title) {
    $(this.tabEl).find('.x-tab-strip-text').text(title);
  },

  setContent: function(content) {
    var pageContainer = this.getPageContainer();
    pageContainer.html(content);
  },

  show: function() {
    Rwiki.Tabs.PageTab.superclass.show.apply(this, arguments);

    this.setTitle(this._page.getTitle());
    this.setContent(this._page.getHtmlContent());

    Rwiki.statusBar.clearStatus({ useDefaults: true });
  },

  getPagePath: function() {
    return this._page.getPath();
  },

  getPageContainer: function() {
    return $('#' + this.id);
  }
});
