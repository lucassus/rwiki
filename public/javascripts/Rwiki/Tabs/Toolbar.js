Ext.ns('Rwiki.Tabs');

Rwiki.Tabs.Toolbar = Ext.extend(Ext.Toolbar, {

  initComponent: function() {
    this.editPageButton = new Rwiki.Button({
      text: 'Edit page',
      iconCls: 'icon-edit',
      scope: this,
      handler: this.onEditPage,
      disabled: true
    });

    this.printPageButton = new Rwiki.Button({
      text: 'Print page',
      iconCls: 'icon-print',
      scope: this,
      handler: this.onPrintPage,
      disabled: true
    });

    this.findPageButton = new Rwiki.Button({
      text: 'Find page',
      iconCls: 'icon-search',
      scope: this,
      handler: this.onFuzzyFinder
    });

    this.findTextButton = new Rwiki.Button({
      text: 'Text search',
      iconCls: 'icon-search',
      scope: this,
      handler: this.onTextSearch
    });

    this.aboutButton = new Rwiki.Button({
      text: 'About',
      iconCls: 'icon-about',
      scope: this,
      handler: this.onAbout
    });

    Ext.apply(this, {
      enableOverflow: true,
      items: [
        this.editPageButton,
        this.printPageButton,
        '-',
        this.findPageButton,
        this.findTextButton,
        '->',
        this.aboutButton
      ]
    });

    Rwiki.Tabs.Toolbar.superclass.initComponent.apply(this, arguments);
  },

  initEvents: function() {
    Rwiki.Tabs.Toolbar.initEvents.appy(this, arguments);
    this.addEvents('rwiki:toolbar:editPage', 'rwiki:toolbar:printPage');
  },

  enablePageRelatedItems: function(){
    this.editPageButton.setDisabled(false);
    this.printPageButton.setDisabled(false);
  },

  disablePageRelatedItems: function() {
    this.editPageButton.setDisabled(true);
    this.printPageButton.setDisabled(true);
  },

  onEditPage: function() {
    this.fireEvent('rwiki:toolbar:editPage');
  },

  onPrintPage: function() {
    this.fireEvent('rwiki:Toolbar:printPage');
  },

  onFuzzyFinder: function() {
    var fuzzyFinder = new Rwiki.Search.FuzzyFinderWindow();
    fuzzyFinder.show();
  },

  onTextSearch: function() {
    var textSearch = new Rwiki.Search.TextSearchWindow();
    textSearch.show();
  },

  onAbout: function() {
    if (!this.aboutDialog) {
      this.aboutDialog = new Rwiki.AboutDialog();
    }

    this.aboutDialog.show();
  }

});

