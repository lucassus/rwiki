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

  isLoading: function() {
    return this._isLoading;
  },

  setIsLoading: function(isLoading) {
    this._isLoading = isLoading;

    if (this.isLoading()) {
      this.mask = new Ext.LoadMask(Ext.get(this.id), {msg: 'Loading the Page...'});
      this.mask.show();
    } else if (this.mask) {
      this.mask.hide();
    }
  },

  getPagePath: function() {
    return this.path;
  },

  setPagePath: function(path) {
    this.path = path;
  },

  setContent: function(htmlContent) {
    var pageContainer = this.getPageContainer();
    pageContainer.html(htmlContent);
  },

  getPageContainer: function() {
    return $('#' + this.id);
  },

  setTitle: function(title) {
    $(this.tabEl).find('.x-tab-strip-text').text(title);
  }
});
